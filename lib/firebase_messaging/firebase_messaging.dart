import 'package:app_mari/configs/app_setting.dart';
import 'package:app_mari/configs/notification_service.dart';
import 'package:app_mari/database/db_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ServiceFirebaseMessaging {
  final NotificationService _notificationService;
  final FirebaseFirestore db = DbFirestore.get();
  final firestore = FirebaseFirestore.instance;
  ServiceFirebaseMessaging(this._notificationService);

  Future<void> initilize() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      badge: true,
      sound: true,
      alert: true,
    );
    getTokenFirebase();
    _onMessage();
  }

  getTokenFirebase() async {
    String? token = await FirebaseMessaging.instance.getToken();
    var snapshot = await firestore.collection('token').get();
    print('Snapshot: ${snapshot.docs.length}');
    if (snapshot.docs.isNotEmpty) {
      Map tokenDatabase = snapshot.docs.first.data();
      tokenDatabase['id'] = snapshot.docs.first.id;
      if (token != tokenDatabase['token']) {
        addTokenFirebase(
          token!,
          tokenDatabase['id'],
          token != tokenDatabase['token'],
        );
      }
      debugPrint('==================================');
      debugPrint('TOKEN: $token');
      debugPrint('TOKEN-DATABASE: $tokenDatabase');
      debugPrint('==================================');
    } else {
      addTokenFirebase(token!, '', false);
    }
  }

  addTokenFirebase(String token, String? tokenId, bool isEdit) async {
    await Modular.get<AppSetting>().startSettings();
    var usuario = await Modular.get<AppSetting>().readLocale();
    if (isEdit) {
      db.collection('token').doc(tokenId).update({'token': token});
    } else {
      await db.collection('token').doc().set(
        {'token': token, 'idUsuario': usuario['id']},
      );
    }
  }

  _onMessage() {
    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        _notificationService.showNotification(
          CustomNotification(
            id: android.hashCode,
            title: notification.title!,
            body: notification.body,
            payload: message.data['route'] ?? '',
          ),
        );
      }
    });
  }

  _onMessageOpenedApp() {
    FirebaseMessaging.onMessageOpenedApp.listen(_goToPageAfterMessage);
  }

  _goToPageAfterMessage(message) {
    final String route = message.data['route'] ?? '';
    if (route.isNotEmpty) {
      Modular.to.pushNamed(route);
    }
  }
}
