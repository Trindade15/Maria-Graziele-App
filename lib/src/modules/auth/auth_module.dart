import 'package:app_mari/configs/app_setting.dart';
import 'package:app_mari/src/modules/auth/pages/auth_register_page.dart';
import 'package:app_mari/src/modules/auth/pages/check_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';
import './auth_controller.dart';
import 'pages/auth_page.dart';

class AuthModule extends Module {
    @override
    final List<Bind> binds = [
      Bind.lazySingleton((i) => AppSetting()),
      Bind.lazySingleton((i) => AuthController()),
    ];
 
    @override
    final List<ModularRoute> routes = [
      ChildRoute('/auth-page', child: (_, args) => AuthPage()),
      ChildRoute('/', child: (_, args) => CheckAuth()),
      ChildRoute('/auth-register-page', child: (_, args) => const AuthRegisterPage()),
    ];
 
}