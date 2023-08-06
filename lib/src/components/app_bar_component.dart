import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppBarComponent extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const AppBarComponent({super.key, this.title = ''});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: Image.asset(
        'assets/images/coroa.png',
        height: 32,
        width: 32,
      ),
      titleSpacing: 0,
      title: Text(
        title,
        style: GoogleFonts.gentiumBookBasic(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
