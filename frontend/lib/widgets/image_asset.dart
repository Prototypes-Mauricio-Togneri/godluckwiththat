import 'package:flutter/material.dart';

class ImageAsset extends StatelessWidget {
  final String path;
  final double size;

  const ImageAsset({
    required this.path,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Image.asset(
        'images/$path',
        fit: BoxFit.cover,
      ),
    );
  }
}
