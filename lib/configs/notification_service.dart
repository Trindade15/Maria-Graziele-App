import 'dart:typed_data';

import 'package:app_mari/src/ui/styles/colors_app.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class CustomNotification {
  final int id;
  final String? title;
  final String? body;
  final String? payload;

  CustomNotification({
    required this.id,
    this.title,
    this.body,
    this.payload,
  });
}

class NotificationService {
  late FlutterLocalNotificationsPlugin localNotificationsPlugin;
  late AndroidNotificationDetails androidDetails;

  NotificationService() {
    localNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _setupNotifications();
  }

  _setupNotifications() async {
    await _setupTimeZone();
    await _initalizeNotifications();
  }

  Future<void> _setupTimeZone() async {
    tz.initializeTimeZones();
    final String timezone = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timezone));
  }

  _initalizeNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    await localNotificationsPlugin.initialize(
      const InitializationSettings(
        android: android,
      ),
      onDidReceiveNotificationResponse: (details) {
        _onSelectNotifications(details.payload);
      },
    );
  }

  _onSelectNotifications(String? payload) {
    if (payload != null && payload.isNotEmpty) {
      Modular.to.navigate('/home-module/');
    }
  }

  showNotification(CustomNotification notification) {
    final date = DateTime.now().add(const Duration(milliseconds: 300));
    androidDetails = AndroidNotificationDetails(
      'lembretes_notifications_x',
      'Lembretes',
      channelDescription: 'Este canal é para lembretes!',
      importance: Importance.max,
      subText: 'Você é lindaaa✨',
      priority: Priority.max,
      visibility: NotificationVisibility.public,
      enableVibration: true,
      playSound: true,
      enableLights: true,
      category: AndroidNotificationCategory.social,
      color: ColorsApp.instance.primary,
    );

    localNotificationsPlugin.zonedSchedule(
      notification.id,
      notification.title,
      notification.body,
      tz.TZDateTime.from(date, tz.local),
      NotificationDetails(android: androidDetails),
      payload: notification.payload,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  checkForNotifications() async {
    final details =
        await localNotificationsPlugin.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      _onSelectNotifications(details.notificationResponse!.payload);
    }
  }

  getTokenFirebase() async =>
      debugPrint(await FirebaseMessaging.instance.getToken());
}
