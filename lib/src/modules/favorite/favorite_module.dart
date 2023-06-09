import 'package:app_mari/src/modules/favorite/favorite_store.dart';
import 'package:app_mari/src/modules/home/controller/home_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import './favorite_page.dart';

class FavoriteModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => HomeController()),
    Bind.lazySingleton((i) => FavoriteStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => const FavoritePage()),
  ];
}
