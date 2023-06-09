import 'package:app_mari/configs/app_setting.dart';
import 'package:app_mari/configs/notification_service.dart';
import 'package:app_mari/firebase_messaging/firebase_messaging.dart';
import 'package:app_mari/src/modules/auth/auth_module.dart';
import 'package:app_mari/src/modules/cartas/cartas_module.dart';
import 'package:app_mari/src/modules/favorite/favorite_module.dart';
import 'package:app_mari/src/modules/home/home_module.dart';
import 'package:app_mari/src/modules/index/index_module.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.singleton(
          (i) => AppSetting(),
          export: true,
        ),
        Bind.lazySingleton((i) => NotificationService()),
        Bind.lazySingleton((i) => ServiceFirebaseMessaging(i()))
      ];

  @override
  List<ModularRoute> get routes => [
        ModuleRoute('/auth-module', module: AuthModule()),
        ModuleRoute('/',
            module: IndexModule(), transition: TransitionType.size),
        ModuleRoute('/home',
            module: HomeModule(), transition: TransitionType.fadeIn),
        ModuleRoute('/favorite',
            module: FavoriteModule(), transition: TransitionType.fadeIn),
        ModuleRoute(
          '/settings',
          module: CartasModule(),
          transition: TransitionType.size,
          duration: const Duration(seconds: 2),
        ),
      ];
}
