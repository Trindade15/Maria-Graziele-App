import 'dart:io';
import 'package:app_mari/configs/app_setting.dart';
import 'package:app_mari/database/db_firestore.dart';
import 'package:app_mari/src/modules/home/components/home_image_detail.dart';
import 'package:app_mari/src/modules/home/home_store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';

class HomeController extends ChangeNotifier {
  List<Map<String, dynamic>> images = [];
  final FirebaseFirestore db = DbFirestore.get();
  final FirebaseStorage storage = FirebaseStorage.instance;
  final firestore = FirebaseFirestore.instance;
  bool uploading = false;
  double total = 0;
  List<Reference> refs = [];

  loadImages() async {
    images.clear();
    await Modular.get<AppSetting>().startSettings();
    var usuario = await Modular.get<AppSetting>().readLocale();
    var snapshot = await firestore
        .collection('images')
        .where('usuarioId', isEqualTo: usuario['id'])
        .get();
    for (var doc in snapshot.docs) {
      var image = doc.data();
      image['id'] = doc.id;
      images.add(image);
    }
    notifyListeners();
    return images;
  }

  UploadTask upload(XFile img) {
    File file = File(img.path);
    String ref = 'images/img-${img.name}-${DateTime.now().toString()}.jpg';
    try {
      return storage.ref(ref).putFile(file);
    } on FirebaseException catch (e) {
      throw Exception('Erro no upload: ${e.code}');
    }
  }

  Future<void> saveDataBase(TaskSnapshot snapshot, Map usuario) async {
    await db.collection('images').doc().set(
      {
        'imagePath': await snapshot.ref.getDownloadURL(),
        'fullPath': snapshot.ref.fullPath,
        'isFavorite': '0',
        'usuarioId': usuario['id'],
      },
    );
  }

  void favoriteImage(ImageDetailInterface detail) async {
    db.collection('images').doc(detail.id).update({
      'isFavorite': detail.isFavorite,
    });
    notifyListeners();
  }

  pickAndUploadImage() async {
    XFile? file = await getImage(ImageSource.gallery);
 
    try {
      if (file != null) {
        print('File: ${file.name}');
        UploadTask task = upload(file);
        print('UploadTask ${task.snapshot.ref.fullPath}');
        task.snapshotEvents.listen((TaskSnapshot snapshot) async {
          if (snapshot.state == TaskState.running) {
            uploading = true;
            total = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
            notifyListeners();
          } else if (snapshot.state == TaskState.success) {
            await Modular.get<AppSetting>().startSettings();
            var usuario = await Modular.get<AppSetting>().readLocale();
            await saveDataBase(snapshot, usuario).then((value) async {
              refs.add(snapshot.ref);
              images.add({
                'imagePath': await snapshot.ref.getDownloadURL(),
                'isFavorite': 0,
                'usuarioId': usuario['id'],
              });
              uploading = false;
              Modular.get<HomeStore>().getImages();
            });
          }
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<XFile?> getImage(ImageSource imageSource) async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: imageSource);
    return image;
  }

  deleteImage(ImageDetailInterface detail) async {
    var index = int.tryParse(detail.tag)!;
    images.removeAt(index);
    await storage.ref(detail.fullPath).delete();
    await db.collection('images').doc(detail.id).delete();
    Modular.to.navigate('/home-module/');
  }
}
