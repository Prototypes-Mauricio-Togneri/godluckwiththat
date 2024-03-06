import 'package:flutter/material.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/misc/image_asset.dart';

class ImageBlock extends StatelessWidget {
  final String path;
  final double size;

  const ImageBlock({
    required this.path,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      color: Palette.grey,
      child: Center(
        child: ImageAsset(
          path: path,
          size: size * 0.7,
        ),
      ),
    );
  }
}
