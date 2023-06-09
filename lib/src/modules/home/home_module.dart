import 'package:app_mari/configs/app_setting.dart';
import 'package:app_mari/configs/notification_service.dart';
import 'package:app_mari/src/modules/auth/auth_controller.dart';
import 'package:app_mari/src/modules/home/components/home_image_detail.dart';
import 'package:app_mari/src/modules/home/controller/home_controller.dart';
import 'package:app_mari/src/modules/home/pages/home_page.dart';
import 'package:app_mari/src/modules/home/home_store.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomeModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.lazySingleton((i) => AppSetting()),
        Bind.lazySingleton((i) => NotificationService()),
        Bind.lazySingleton((i) => HomeController()),
        Bind.lazySingleton((i) => HomeStore(i())),
        Bind.lazySingleton((i) => AuthController())
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (context, args) => const HomePage()),
        ChildRoute('/home-detail',
            child: (context, args) => HomeImageDetail(imageDetail: args.data)),
      ];
}
