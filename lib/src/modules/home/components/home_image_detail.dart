import 'package:app_mari/src/modules/home/controller/home_controller.dart';
import 'package:app_mari/src/ui/styles/colors_app.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:share_plus/share_plus.dart';

import '../../../components/open_image_component.dart';

class HomeImageDetail extends StatefulWidget {
  final ImageDetailInterface imageDetail;
  const HomeImageDetail({super.key, required this.imageDetail});

  @override
  State<HomeImageDetail> createState() => _HomeImageDetailState();
}

class _HomeImageDetailState extends State<HomeImageDetail> {
  bool get isFavoriteParse {
    return widget.imageDetail.isFavorite == '0' ? false : true;
  }

  @override
  Widget build(BuildContext context) {
    bool isFavorite = isFavoriteParse;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Visibility(
          visible: isFavorite,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: context.colors.secondary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              'Favorited',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: context.colors.secondary,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                shareImage();
              });
            },
            icon: Icon(Icons.share, color: context.colors.secondary),
          ),
          IconButton(
            onPressed: () => showSimpleDialog(),
            icon: Icon(Icons.delete_rounded, color: context.colors.secondary),
          ),
        ],
      ),
      body: OpenImageComponent(detail: widget.imageDetail),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 25, right: 10),
        child: FloatingActionButton(
          backgroundColor: Colors.blue[50],
          elevation: 5,
          onPressed: () => setState(() {
            isFavorite = !isFavorite;
          }),
          child: FavoriteButton(
            isFavorite: isFavorite,
            iconSize: 35,
            iconColor: context.colors.secondary,
            iconDisabledColor: Colors.grey,
            valueChanged: (bool value) {
              if (value == false) {
                widget.imageDetail.isFavorite = '0';
              } else {
                widget.imageDetail.isFavorite = '1';
              }
              setState(() {
                isFavorite = value;
                addImageFavorite();
              });
            },
          ),
        ),
      ),
    );
  }

  void shareImage() async {
    final image = widget.imageDetail;
    await Share.share(image.imagePath, subject: 'Confira só essa arte');
  }

  void addImageFavorite() {
    widget.imageDetail.controller!.favoriteImage(widget.imageDetail);
  }

  Future<void> showSimpleDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text(
            'Deseja excluir?',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 20,
            ),
          ),
          children: [
            SimpleDialogOption(
              child: Text(
                'Yes',
                style: TextStyle(color: context.colors.secondary, fontSize: 16),
              ),
              onPressed: () {
                setState(() {
                  widget.imageDetail.controller!.deleteImage(widget.imageDetail);
                });
              },
            ),
            SimpleDialogOption(
              child: Text(
                'Not',
                style: TextStyle(color: Colors.blue[300], fontSize: 16),
              ),
              onPressed: () {
                Modular.to.pop();
              },
            )
          ],
        );
      },
    );
  }
}

class ImageDetailInterface {
  final String tag;
  final String imagePath;
  final String fullPath;
  final String date;
  final String hour;
  final String usuarioId;
  final String id;
  final HomeController? controller;
  String isFavorite;
  ImageDetailInterface({
    required this.tag,
    required this.imagePath,
    required this.fullPath,
    required this.isFavorite,
    required this.usuarioId,
    required this.date,
    required this.hour,
    this.controller,
    required this.id,
  });

  @override
  String toString() =>
      'ImageDetailInterface(tag: $tag, imagePath: $imagePath, isFavorite: $isFavorite)';
}
