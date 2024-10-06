import 'package:flutter/material.dart';
import 'package:godluckwiththat/widgets/images/image_asset.dart';

class ImageBlock extends StatelessWidget {
  final String path;
  final double size;

  const ImageBlock({
    required this.path,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return ImageAsset(
      path: path,
      size: size,
    );
  }
}
