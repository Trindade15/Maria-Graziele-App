import 'package:flutter_modular/flutter_modular.dart';
import './music_page.dart';

class MusicModule extends Module {
    @override
    final List<Bind> binds = [
      //Bind.lazySingleton((i) => MusicController()),
    ];
 
    @override
    final List<ModularRoute> routes = [
      ChildRoute('/', child: (_, args) => MusicPage()),
    ];
 
}