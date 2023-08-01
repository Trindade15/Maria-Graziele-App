import 'package:app_mari/src/modules/album_photos/controller/album_photos_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

import '../../../configs/app_setting.dart';

class AlbumStore extends NotifierStore<ErrorAlbumState, SuccessAlbumState> {
  AlbumController controller;
  AlbumStore(this.controller) : super(SuccessAlbumState([]));
  final firestore = FirebaseFirestore.instance;

  buscarimages() async {
    setLoading(true);
    try {
      var result = await _getImage();
      update(SuccessAlbumState(result));
    } catch (e) {
      setError(ErrorAlbumState(e.toString()));
    } finally {
      setLoading(false);
    }
  }

  _getImage() async {
    controller.images.clear();
    await Modular.get<AppSetting>().startSettings();
    //var usuario = await Modular.get<AppSetting>().readLocale();
    var snapshot = await firestore.collection('album').get();
    for (var doc in snapshot.docs) {
      var image = doc.data();
      image['id'] = doc.id;
      controller.images.add(image);
    }
    return controller.images;
  }
}

//////STATE////////
abstract class AlbumState {}

class SuccessAlbumState extends AlbumState {
  final List<Map> images;
  SuccessAlbumState(this.images);
}

class LoadingAlbumState extends AlbumState {}

class ErrorAlbumState extends AlbumState {
  final String message;
  ErrorAlbumState(this.message);
}
