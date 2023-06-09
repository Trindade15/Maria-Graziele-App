import 'package:app_mari/src/helpers/size_extensions.dart';
import 'package:app_mari/src/modules/settings/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';

class LetterPage extends StatelessWidget {
  final CartaInterface carta;
  const LetterPage({required this.carta});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            'assets/images/background-star.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: context.screenHeight,
          ),
          Positioned(
            top: 50,
            child: Text(
              carta.titulo ?? '',
              style: GoogleFonts.aladin(color: Colors.white, fontSize: 25),
            ),
          ),
          Positioned(
            left: 20,
            top: 50,
            child: CircleAvatar(
              backgroundColor: Colors.white24,
              radius: 18,
              child: IconButton(
                onPressed: () => Modular.to.pop(),
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Colors.white),
              ),
            ),
          ),
          Positioned(
            top: 120,
            left: 16,
            right: 16,
            child: Text(
              carta.carta,
              style: GoogleFonts.aladin(color: Colors.white, fontSize: 17),
            ),
          ),
        ],
      ),
    );
  }
}
