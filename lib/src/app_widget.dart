import 'package:app_mari/configs/notification_service.dart';
import 'package:app_mari/firebase_messaging/firebase_messaging.dart';
import 'package:app_mari/src/ui/styles/colors_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  checkNotifications() async {
    await context.watch<NotificationService>().checkForNotifications();
  }

  static final _defaultInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
    borderSide: const BorderSide(color: Colors.white),
  );

  @override
  void initState() {
    Modular.get<ServiceFirebaseMessaging>().initilize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    checkNotifications();
    Modular.setInitialRoute('/auth-module/');
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Application Name',
      theme: ThemeData(
        primaryColor: context.colors.primary,
        appBarTheme: AppBarTheme(
          color: ColorsApp.instance.primary,
          titleTextStyle: const TextStyle(color: Colors.grey, fontSize: 18),
        ),
        scaffoldBackgroundColor: Colors.blue[50],
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: const TextStyle(color: Colors.white),
          isDense: true,
          contentPadding: const EdgeInsets.all(16),
          border: _defaultInputBorder,
          enabledBorder: _defaultInputBorder,
          focusedBorder: _defaultInputBorder,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(context.colors.primary),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ),
      routeInformationParser: Modular.routeInformationParser,
      routerDelegate: Modular.routerDelegate,
    );
  }
}
