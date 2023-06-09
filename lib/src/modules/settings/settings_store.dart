import 'package:app_mari/src/modules/settings/settings_controller.dart';
import 'package:flutter_triple/flutter_triple.dart';

class SettingsStore
    extends NotifierStore<ErrorSettingsState, SuccessSettingsState> {
  SettingsController controller;
  SettingsStore(this.controller) : super(SuccessSettingsState({}));

  buscarUsuario() async {
    setLoading(true);
    try {
      var usuario = await controller.getUser();
      Future.delayed(
        const Duration(seconds: 1),
        () => update(SuccessSettingsState(usuario)),
      );
      update(SuccessSettingsState(usuario));
    } catch (e) {
      setError(ErrorSettingsState(e.toString()));
    } finally {
      setLoading(false);
    }
  }
}

abstract class SettingsState {}

class SuccessSettingsState extends SettingsState {
  final Map usuario;
  SuccessSettingsState(this.usuario);
}

class LoadingSettingsState extends SettingsState {}

class ErrorSettingsState extends SettingsState {
  final String message;
  ErrorSettingsState(this.message);
}
