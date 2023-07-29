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
    return SizedBox(
      width: width ?? size,
      height: height ?? size,
      child: Image.asset(
        path,
        fit: BoxFit.cover,
      ),
    );
  }
}
