import 'package:app_mari/src/ui/styles/colors_app.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  int indexSelected = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const RouterOutlet(),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: context.colors.primary,
        height: 60,
        index: indexSelected,
        onTap: (int index) {
          setState(() {
            indexSelected = index;
            indexSelectedPage(index);
          });
        },
        items: const [
          Icon(Icons.home, color: Colors.black54),
          Icon(Icons.favorite, color: Colors.black54),
          Icon(Icons.mail_outline_outlined, color: Colors.black54),
          Icon(Icons.settings, color: Colors.black54),
        ],
      ),
    );
  }

  indexSelectedPage(int index) {
    switch (index) {
      case 0:
        Modular.to.navigate('/home-module/');
        break;
      case 1:
        Modular.to.navigate('/favorite-module/');
        break;
      case 2:
        Modular.to.navigate('/cartas-module/');
        break;
        case 3:
        Modular.to.navigate('/settings-module/');
        break;
      default:
    }
  }
}
