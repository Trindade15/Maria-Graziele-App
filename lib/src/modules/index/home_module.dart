import 'package:app_mari/configs/app_setting.dart';
import 'package:app_mari/src/modules/index/index_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class IndexModule extends Module {

   @override
   List<Bind> get binds => [
    Bind((i) => AppSetting()),
   ];

   @override
   List<ModularRoute> get routes => [
      ChildRoute('/', child: (context, args) => IndexPage()),
   ];

}