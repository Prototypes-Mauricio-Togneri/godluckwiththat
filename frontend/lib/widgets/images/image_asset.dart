import 'package:flutter/material.dart';

class ImageAsset extends StatelessWidget {
  final String path;
  final double? width;
  final double? height;
  final double? size;

  const ImageAsset({
    required this.path,
    this.width,
    this.height,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      path,
      width: width ?? size,
      height: height ?? size,
      fit: BoxFit.cover,
    );
  }
}
