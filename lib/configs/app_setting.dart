import 'dart:convert';

import 'package:app_mari/src/modules/home/components/home_image_detail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSetting extends ChangeNotifier {
  late SharedPreferences _prefs;
  Map<dynamic, dynamic> storage = {};
  String _usuario = '';

  AppSetting() {
    startSettings();
  }

  Future<void> startSettings() async {
    await _startPreferences();
    //await readLocale();
  }

  Future<void> _startPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  updateStorage() async {
    await _prefs.reload();
    return storage;
  }

  Future<Map> readLocale() async {
    storage.clear();
    final usuario = _prefs.getString('usuario') ?? {};
    Map map = json.decode(usuario.toString());
    storage = map;
    notifyListeners();
    return map;
  }

  removeImagePath(ImageDetailInterface path) async {
    if (_usuario.isNotEmpty) {
      _usuario = '';
      await _prefs.setString('usuario', _usuario);
      readLocale();
    }
  }

  Future<void> setUsuario(UserCredential userCredential) async {
    User? user = userCredential.user;
    _usuario =
        '{ "id": "${user!.uid}", "nome": "${user.displayName}", "email": "${user.email}" }';
    await _prefs.setString('usuario', _usuario);
    await readLocale();
  }
}
