import 'package:flutter/material.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/utils/palette.dart';

class Label extends StatelessWidget {
  final String text;
  final Color color;
  final double size;
  final FontWeight weight;
  final TextDecoration decoration;
  final TextAlign? align;
  final TextOverflow? overflow;
  final int? maxLines;

  const Label({
    required this.text,
    this.color = Palette.white,
    this.size = 14,
    this.weight = FontWeight.bold,
    this.decoration = TextDecoration.none,
    this.align,
    this.overflow,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: size / 2),
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
        ),
      ),
    );
  }
}
