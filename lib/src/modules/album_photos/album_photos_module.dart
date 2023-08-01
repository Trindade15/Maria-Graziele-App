import 'package:app_mari/src/modules/album_photos/abum_photos_store.dart';
import 'package:app_mari/src/modules/album_photos/controller/album_photos_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import './album_photos_page.dart';

class AlbumPhotosModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => AlbumController()),
    Bind.lazySingleton((i) => AlbumStore(i()))
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => AlbumPhotosPage()),
  ];
}
