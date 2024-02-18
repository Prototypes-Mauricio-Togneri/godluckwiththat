import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/image_asset.dart';
import 'package:godluckwiththat/widgets/label.dart';

class ResourceIndicator extends StatelessWidget {
  final String sprite;
  final String value;
  final double textSize;
  final double iconSize;
  final Color textColor;

  const ResourceIndicator({
    required this.sprite,
    required this.value,
    required this.textSize,
    required this.iconSize,
    this.textColor = Palette.white,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Label(
          text: value,
          size: textSize,
          color: textColor,
        ),
        HBox((textSize + iconSize) / 4),
        ImageAsset(
          path: sprite,
          size: iconSize,
        ),
      ],
    );
  }
}
