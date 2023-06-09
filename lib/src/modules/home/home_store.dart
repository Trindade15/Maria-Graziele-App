import 'package:app_mari/src/modules/home/controller/home_controller.dart';
import 'package:flutter_triple/flutter_triple.dart';

class HomeStore extends NotifierStore<ErrorHomeState, SuccessHomeState> {
  HomeController controller;
  HomeStore(this.controller) : super(SuccessHomeState([]));

  getImages() async {
    setLoading(true);
    try {
    var images = await controller.loadImages();
      update(SuccessHomeState(images));
    } catch (e) {
      setError(ErrorHomeState(e.toString()));
    } finally {
      setLoading(false);
    }
  }
}

abstract class HomeState {}
class SuccessHomeState extends HomeState {
  final List<Map> images;
  SuccessHomeState(this.images);
}

class LoadingHomeState extends HomeState {}

class ErrorHomeState extends HomeState {
  final String message;
  ErrorHomeState(this.message);
}
