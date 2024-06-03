import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Color maincolor = const Color(0xff78AEA8);

class MainFont extends StatelessWidget {
  final String title;
  final double? fsize;
  final FontWeight? fweight;
  final Color? color;
  final TextAlign? align;
  const MainFont(
      {super.key,
      required this.title,
      this.fsize,
      this.fweight,
      this.color,
      this.align});

  @override
  Widget build(BuildContext context) {
    return Text(
      overflow: TextOverflow.ellipsis,
      title,
      textAlign: align,
      style: GoogleFonts.poppins(
        textStyle:
            TextStyle(color: color, fontWeight: fweight, fontSize: fsize),
      ),
    );
  }
}
