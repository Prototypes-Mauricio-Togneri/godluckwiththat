import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/image_asset.dart';
import 'package:godluckwiththat/widgets/label.dart';
import 'package:godluckwiththat/widgets/tooltip.dart';

class ResourceIndicator extends StatelessWidget {
  final String sprite;
  final String value;
  final String? tooltip;
  final Color textColor;

  const ResourceIndicator({
    required this.sprite,
    required this.value,
    this.tooltip,
    this.textColor = Palette.white,
  });

  @override
  Widget build(BuildContext context) {
    final Widget content = Padding(
      padding: const EdgeInsets.only(
        top: 5,
        bottom: 5,
        left: 15,
        right: 15,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ImageAsset(
            path: sprite,
            size: 28,
          ),
          const HBox(10),
          Label(
            text: value,
            size: 30,
            color: textColor,
          ),
        ],
      ),
    );

    if (tooltip != null) {
      return CustomTooltip(
        content: Label(
          text: tooltip!,
          color: Palette.white,
          size: 30,
        ),
        child: content,
      );
    } else {
      return content;
    }
  }
}
