import 'package:flutter/material.dart';

class ImageGrayScale extends StatelessWidget {
  final Widget child;
  final double size;

  const ImageGrayScale({
    required this.child,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: const ColorFilter.matrix([
        0.2126, 0.7152, 0.0722, 0, 0, //
        0.2126, 0.7152, 0.0722, 0, 0, //
        0.2126, 0.7152, 0.0722, 0, 0, //
        0, 0, 0, 1, 0, //
      ]),
      child: child,
    );
  }
}
