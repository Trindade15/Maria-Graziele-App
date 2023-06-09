import 'package:app_mari/src/modules/cartas/cartas_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

class CartasStore
    extends NotifierStore<ErrorSettingsState, SuccessSettingsState> {
  final controller = Modular.get<CartasController>();
  CartasStore() : super(SuccessSettingsState([]));

  getCartas() async {
    setLoading(true);
    try {
      controller.startRepository();
      var cartas = await controller.getCartas();
      update(SuccessSettingsState(cartas));
    } catch (e) {
      setError(ErrorSettingsState(e.toString()));
    } finally {
      setLoading(false);
    }
  }
}

abstract class SettingsState {}

class InitialSettingsState extends SettingsState {}

class SuccessSettingsState extends SettingsState {
  final List<dynamic> cartas;
  SuccessSettingsState(this.cartas);
}

class LoadingSettingsState extends SettingsState {}

class ErrorSettingsState extends SettingsState {
  final String message;
  ErrorSettingsState(this.message);
}
