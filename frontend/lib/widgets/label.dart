import 'package:flutter/material.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/services/palette.dart';

class Label extends StatelessWidget {
  final String text;
  final Color color;
  final double size;
  final FontWeight weight;
  final TextDecoration decoration;
  final TextAlign? align;
  final TextOverflow? overflow;
  final GestureTapCallback? onTap;
  final int? maxLines;

  const Label({
    required this.text,
    this.color = Palette.white,
    this.size = 14,
    this.weight = FontWeight.bold,
    this.decoration = TextDecoration.none,
    this.align,
    this.overflow,
    this.onTap,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        textAlign: align,
        maxLines: maxLines,
        style: TextStyle(
          color: color,
          fontSize: size,
          fontWeight: weight,
          fontFamily: Constants.FONT_NAME,
          decoration: decoration,
          height: 1,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
