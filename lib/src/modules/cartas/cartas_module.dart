


import 'package:app_mari/src/modules/cartas/cartas_store.dart';
import 'package:app_mari/src/modules/cartas/pages/cartas_lista_page.dart';
import 'package:app_mari/src/modules/cartas/pages/cartas_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'cartas_controller.dart';

class CartasModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => CartasController()),
    Bind.lazySingleton((i) => CartasStore())
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => const CartasListaPage()),
    ChildRoute('/letter-page', child: (_, args) => CartasPage(carta: args.data)),
  ];
}
