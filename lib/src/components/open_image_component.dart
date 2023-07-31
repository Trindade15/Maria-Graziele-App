import 'package:app_mari/src/helpers/size_extensions.dart';
import 'package:app_mari/src/modules/home/components/home_image_detail.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OpenImageComponent extends StatelessWidget {
  final ImageDetailInterface detail;
  const OpenImageComponent({required this.detail});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: detail.tag,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 5),
              child: Text(
                '${detail.date} - ${detail.hour}',
                style: GoogleFonts.aBeeZee(color: Colors.black, fontSize: 13),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  height: context.screenHeight * .6, 
                  child: Image.network(
                    detail.imagePath,
                    fit: BoxFit.scaleDown,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset('assets/images/image-found.jpg');
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
