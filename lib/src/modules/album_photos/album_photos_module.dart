import 'package:app_mari/src/modules/album_photos/abum_photos_store.dart';
import 'package:app_mari/src/modules/album_photos/components/album_image_detail.dart';
import 'package:app_mari/src/modules/album_photos/controller/album_photos_controller.dart';
import 'package:app_mari/src/modules/settings/settings_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import './album_photos_page.dart';

class AlbumPhotosModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => AlbumController()),
    Bind.lazySingleton((i) => AlbumStore(i())),
    Bind.lazySingleton((i) => SettingsController()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => const AlbumPhotosPage()),
    ChildRoute('/album-detail', child: (_, args) => AlbumImageDetail(args.data)),
  ];
}
