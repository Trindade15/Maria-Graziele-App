import 'package:app_mari/configs/app_setting.dart';
import 'package:app_mari/src/modules/auth/auth_controller.dart';
import 'package:app_mari/src/modules/home/controller/home_controller.dart';
import 'package:app_mari/src/modules/settings/settings_controller.dart';
import 'package:app_mari/src/modules/settings/settings_store.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'settings_page.dart';

class SettingsModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => AppSetting()),
    Bind.lazySingleton((i) => AuthController()),
    Bind.lazySingleton((i) => HomeController()),
    Bind.lazySingleton((i) => SettingsController()),
    Bind.lazySingleton((i) => SettingsStore(i()))
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => SettingsPage()),
  ];
}
