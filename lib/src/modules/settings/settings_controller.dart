import 'dart:io';

import 'package:app_mari/configs/app_setting.dart';
import 'package:app_mari/database/db_firestore.dart';
import 'package:app_mari/src/modules/settings/settings_store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';

class SettingsController extends ChangeNotifier {
  final firestore = FirebaseFirestore.instance;
  final FirebaseFirestore db = DbFirestore.get();
  final FirebaseStorage storage = FirebaseStorage.instance;
  Map avatar = {};

  bool uploading = false;
  double total = 0;
  Reference? ref;

  Future<Map> getUser() async {
    await Modular.get<AppSetting>().startSettings();
    var usuario = await Modular.get<AppSetting>().readLocale();
    var snapshot = await firestore
        .collection('usuarios')
        .where('id', isEqualTo: usuario['id'])
        .get();
    var user = snapshot.docs.first.data();
    user['docId'] = snapshot.docs.first.id;
    avatar = user;
    return user;
  }

  UploadTask upload(XFile img) {
    File file = File(img.path);
    String ref =
        'usuarios/images/img-${img.name}-${DateTime.now().toString()}.jpg';
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

  Future<void> saveDataBase(TaskSnapshot snapshot, Map usuario) async {
    print('UsuarioId: ${usuario['id']}');
    print('URL: ${await snapshot.ref.getDownloadURL()}');
    await db.collection('usuarios').doc(avatar['docId']).update(
      {'avatarUrl': await snapshot.ref.getDownloadURL()},
    );
  }

  saveAvatar() async {
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
              ref = snapshot.ref;
              uploading = false;
            });
            await Modular.get<SettingsStore>().buscarUsuario();
          }
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
