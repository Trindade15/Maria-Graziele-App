import 'package:app_mari/src/modules/favorite/favorite_store.dart';
import 'package:app_mari/src/modules/favorite/pages/favorite_detail.dart';
import 'package:app_mari/src/modules/home/controller/home_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'pages/favorite_page.dart';

class FavoriteModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => HomeController()),
    Bind.lazySingleton((i) => FavoriteStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => const FavoritePage()),
    ChildRoute('/favorite-detail', child: (context, args) => FavoriteDetail(detail: args.data))
  ];
}
