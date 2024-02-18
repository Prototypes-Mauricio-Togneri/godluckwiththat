import 'package:flutter/material.dart';
import 'package:godluckwiththat/app/constants.dart';
import 'package:godluckwiththat/utils/palette.dart';

class Label extends StatelessWidget {
  final String text;
  final Color color;
  final double size;
  final FontWeight weight;
  final TextDecoration decoration;
  final TextAlign? align;
  final TextOverflow? overflow;
  final int? maxLines;
  final double? height;

  const Label({
    required this.text,
    this.color = Palette.white,
    this.size = 14,
    this.weight = FontWeight.normal,
    this.decoration = TextDecoration.none,
    this.align,
    this.overflow,
    this.maxLines,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      textAlign: align,
      maxLines: maxLines,
      style: TextStyle(
        color: color,
        //height: 0.2,
        fontSize: size,
        fontWeight: weight,
        fontFamily: Constants.FONT_NAME,
        decoration: decoration,
      ),
    );
  }
}
