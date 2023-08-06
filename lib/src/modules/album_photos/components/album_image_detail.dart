import 'package:app_mari/src/components/app_bar_component.dart';
import 'package:app_mari/src/helpers/size_extensions.dart';
import 'package:app_mari/src/modules/album_photos/models/album_model.dart';
import 'package:app_mari/src/modules/home/components/home_image_detail.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AlbumImageDetail extends StatelessWidget {
  final AlbumModel image;
  const AlbumImageDetail(this.image, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const AppBarComponent(title: 'I and he'),
      body: Container(
        height: context.screenHeight,
        padding: const EdgeInsets.only(top: 100, left: 16, right: 16),
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(0, 44, 118, 1),
              Colors.blue,
              Colors.black,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Image.network(
                image.imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
                height: context.screenHeight * 0.7,
              ),
            ),
            const SizedBox(height: 24),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(
                Icons.add_comment_outlined,
                textDirection: TextDirection.rtl,
                color: Colors.white,
                size: 20,
              ),
              label: Text(
                'Add comment',
                style: GoogleFonts.gentiumBookBasic(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  ImageDetailInterface imageParse() {
    var img = ImageDetailInterface(
      tag: 'img-3',
      imagePath: image.imagePath,
      fullPath: image.fullPath,
      isFavorite: image.isFavorite,
      usuarioId: image.usuarioId ?? '',
      date: image.date,
      hour: image.hour,
      id: '',
      comentario: image.comentario,
      avatarUrl: image.avatarUrl,
    );
    return img;
  }
}
