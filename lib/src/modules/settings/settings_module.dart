import 'package:app_mari/src/modules/settings/pages/letter_page.dart';
import 'package:app_mari/src/modules/settings/settings_controller.dart';
import 'package:app_mari/src/modules/settings/settings_store.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'pages/settings_page.dart';

class SettingsModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => SettingsController()),
    Bind.lazySingleton((i) => SettingsStore())
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => const SettingsPage()),
    ChildRoute('/letter-page', child: (_, args) => LetterPage(carta: args.data)),
  ];
}
