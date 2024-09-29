import 'package:flutter/material.dart';
import 'package:godluckwiththat/app/constants.dart';
import 'package:godluckwiththat/utils/palette.dart';

class Label extends StatelessWidget {
  final String text;
  final Color color;
  final double size;
  final FontWeight weight;
  final TextDecoration decoration;
  final bool uppercase;
  final TextAlign? align;
  final TextOverflow? overflow;
  final int? maxLines;
  final double? height;

  const Label({
    required this.text,
    this.color = Palette.white,
    this.size = 12,
    this.weight = FontWeight.normal,
    this.decoration = TextDecoration.none,
    this.uppercase = false,
    this.align,
    this.overflow,
    this.maxLines,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      uppercase ? text.toUpperCase() : text,
      textAlign: align,
      maxLines: maxLines,
      style: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: weight,
        fontFamily: Constants.FONT_NAME,
        decoration: decoration,
      ),
    );
  }
}
