import 'package:app_mari/configs/app_setting.dart';
import 'package:app_mari/configs/notification_service.dart';
import 'package:app_mari/firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:provider/provider.dart';
import './src/app_module.dart';
import './src/app_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        Provider<NotificationService>(
          create: (context) => NotificationService(),
        ),
        Provider<ServiceFirebaseMessaging>(
          create: (context) =>
              ServiceFirebaseMessaging(Modular.get<NotificationService>()),
        ),
        Provider<AppSetting>(create: (context) => AppSetting()),
      ],
      child: ModularApp(
        module: AppModule(),
        child: const AppWidget(),
      ),
    ),
  );
}
