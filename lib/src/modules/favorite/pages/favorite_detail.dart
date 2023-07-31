import 'package:app_mari/src/components/open_image_component.dart';
import 'package:app_mari/src/modules/home/components/home_image_detail.dart';
import 'package:app_mari/src/ui/styles/colors_app.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FavoriteDetail extends StatelessWidget {
  final ImageDetailInterface detail;
  const FavoriteDetail({required this.detail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: context.colors.secondary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            OpenImageComponent(detail: detail),
            Visibility(
              visible: detail.comentario != null && detail.comentario != '',
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
                    Stack(
                      children: [
                        Text(
                          detail.comentario ?? '',
                          style: GoogleFonts.aBeeZee(),
                        ),
                      ],
                    ),
                  ], 
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
