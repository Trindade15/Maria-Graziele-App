import 'package:app_mari/configs/app_setting.dart';
import 'package:app_mari/src/modules/settings/settings_module.dart';
import 'package:app_mari/src/modules/favorite/favorite_module.dart';
import 'package:app_mari/src/modules/home/home_module.dart';
import 'package:app_mari/src/modules/index/index_page.dart';
import 'package:app_mari/src/modules/music/music_module.dart';
import 'package:app_mari/src/modules/cartas/cartas_module.dart';
import 'package:flutter_modular/flutter_modular.dart';

class IndexModule extends Module {
  @override
  List<Bind> get binds => [
        Bind((i) => AppSetting()),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          '/',
          child: (context, args) => const IndexPage(),
          transition: TransitionType.fadeIn,
          children: [
            ModuleRoute('/home-module', module: HomeModule()),
            ModuleRoute('/favorite-module', module: FavoriteModule()),
            ModuleRoute('/cartas-module', module: CartasModule()),
            ModuleRoute('/settings-module', module: SettingsModule()),
            ModuleRoute('/music-module', module: MusicModule()),
          ]
        ),
      ];
}
