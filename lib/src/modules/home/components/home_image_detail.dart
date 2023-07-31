import 'package:app_mari/src/helpers/size_extensions.dart';
import 'package:app_mari/src/modules/home/controller/home_controller.dart';
import 'package:app_mari/src/ui/styles/colors_app.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:share_plus/share_plus.dart';

import '../../../components/open_image_component.dart';

class HomeImageDetail extends StatefulWidget {
  final ImageDetailInterface imageDetail;
  const HomeImageDetail({super.key, required this.imageDetail});

  @override
  State<HomeImageDetail> createState() => _HomeImageDetailState();
}

class _HomeImageDetailState extends State<HomeImageDetail> {
  final commentController = TextEditingController();
  final changeText = ValueNotifier<String>('Ex: Essa foto é muito bonita');
  bool get isFavoriteParse {
    return widget.imageDetail.isFavorite == '0' ? false : true;
  }

  @override
  void initState() {
    if (widget.imageDetail.comentario != null) {
      commentController.text = widget.imageDetail.comentario!;
      changeText.value = widget.imageDetail.comentario!;
    }
    super.initState();
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
          IconButton(
            onPressed: () => addComment(),
            icon: Icon(
              Icons.maps_ugc,
              color: context.colors.secondary,
              //size: 27,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            OpenImageComponent(detail: widget.imageDetail),
            Visibility(
              visible: widget.imageDetail.comentario != null &&
                  widget.imageDetail.comentario != '',
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Comment:',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.imageDetail.comentario ?? '',
                      style: GoogleFonts.aBeeZee(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20, right: 10),
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

  addComment() {
    var outilineBorder = OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.grey),
      borderRadius: BorderRadius.circular(20),
    );
    return showBarModalBottomSheet(
      backgroundColor: context.colors.primary,
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.only(left: 10, top: 20, right: 10),
          height: context.screenHeight * .6,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'Write a comment',
                  style: GoogleFonts.aBeeZee(fontSize: 16, color: Colors.black),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextFormField(
                    controller: commentController,
                    onChanged: (value) {
                      setState(() {
                        changeText.value = value;
                      });
                    },
                    maxLength: 300,
                    decoration: InputDecoration(
                      label: Text(
                        'Comment',
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                      ),
                      enabledBorder: outilineBorder,
                      disabledBorder: outilineBorder,
                      focusedBorder: outilineBorder,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: ValueListenableBuilder(
                    valueListenable: changeText,
                    builder: (context, text, child) => Text(
                      text,
                      style: GoogleFonts.aBeeZee(color: Colors.grey[600]),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Visibility(
                  visible: commentController.text.isNotEmpty,
                  child: SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(context.colors.secondary),
                      ),
                      onPressed: () async {
                        await widget.imageDetail.controller!.addComentario(
                          widget.imageDetail,
                          commentController.text,
                        );
                      },
                      child: const Icon(Icons.bookmark_add_outlined),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).then((value) {
      setState(() {
        if (widget.imageDetail.comentario == null) commentController.clear();
        changeText.value =
            widget.imageDetail.comentario ?? 'Ex: Essa foto é muito bonita';
      });
    });
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
                  widget.imageDetail.controller!
                      .deleteImage(widget.imageDetail);
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
  final String? comentario;
  final String usuarioId;
  final String id;
  final HomeController? controller;
  String isFavorite;
  ImageDetailInterface(
      {required this.tag,
      required this.imagePath,
      required this.fullPath,
      required this.isFavorite,
      required this.usuarioId,
      required this.date,
      required this.hour,
      this.controller,
      required this.id,
      required this.comentario});

  @override
  String toString() =>
      'ImageDetailInterface(tag: $tag, imagePath: $imagePath, isFavorite: $isFavorite)';
}
