import 'package:flutter/material.dart';

class ColorsApp {
  static ColorsApp? _instance;
  ColorsApp._();
  static ColorsApp get instance {
    _instance ??= ColorsApp._();
    return _instance!;
  }

  Color get primary => Colors.blue[50]!;
  Color get secondary =>  Colors.red[300]!;
}

extension ColorsAppExceptions on BuildContext {
  ColorsApp get colors => ColorsApp.instance;
}
