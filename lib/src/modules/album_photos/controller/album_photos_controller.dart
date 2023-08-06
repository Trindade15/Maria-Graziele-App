import 'dart:io';

import 'package:app_mari/src/modules/album_photos/abum_photos_store.dart';
import 'package:app_mari/src/modules/settings/settings_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../configs/app_setting.dart';
import '../../../../database/db_firestore.dart';

class AlbumController extends ChangeNotifier {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseFirestore db = DbFirestore.get();
  bool uploading = false;
  double total = 0;
  List<Reference> refs = [];
  List<Map<String, dynamic>> images = [];
  var settingController = SettingsController();

  pickAndUploadImage() async {
    XFile? file = await getImage(ImageSource.gallery);
    try {
      if (file != null) {
        UploadTask task = upload(file);
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
              Modular.get<AlbumStore>().buscarimages();
            });
          }
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> saveDataBase(TaskSnapshot snapshot, Map usuario) async {
    var data = DateTime.now();
    var date = '${data.day}-${data.month}-${data.year}';
    await db.collection('album').doc().set(
      {
        'imagePath': await snapshot.ref.getDownloadURL(),
        'fullPath': snapshot.ref.fullPath,
        'isFavorite': '0',
        'usuarioId': usuario['id'],
        'date': date,
        'hour': '${data.hour}:${data.minute}',
        'comentario': null,
      },
    );
  }

  UploadTask upload(XFile img) {
    File file = File(img.path);
    String ref = 'album/img-${img.name}-${DateTime.now().toString()}.jpg';
    try {
      return storage.ref(ref).putFile(file);
    } on FirebaseException catch (e) {
      throw Exception('Erro no upload: ${e.code}');
    }
  }

  Future<XFile?> getImage(ImageSource imageSource) async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: imageSource);
    return image;
  }
}
