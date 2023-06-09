import 'package:app_mari/src/modules/home/controller/home_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

class FavoriteStore
    extends NotifierStore<ErrorFavoriteState, SuccessFavoriteState> {
  FavoriteStore() : super(SuccessFavoriteState([]));

  getFavoritePhotos() async {
    setLoading(true);
    try {
      var imagesFavorites = await Modular.get<HomeController>().loadImages();
      Future.delayed(
        const Duration(seconds: 1),
        () => update(SuccessFavoriteState(imagesFavorites)),
      );
    } catch (e) {
      setError(ErrorFavoriteState(e.toString()));
    } finally {
      setLoading(false);
    }
  }
}

abstract class FavoriteState {}

class InitialFavoriteState extends FavoriteState {}

class SuccessFavoriteState extends FavoriteState {
  final List<Map<dynamic, dynamic>> favorites;
  SuccessFavoriteState(this.favorites);
}

class LoadingFavoriteState extends FavoriteState {}

class ErrorFavoriteState extends FavoriteState {
  final String message;
  ErrorFavoriteState(this.message);
}
