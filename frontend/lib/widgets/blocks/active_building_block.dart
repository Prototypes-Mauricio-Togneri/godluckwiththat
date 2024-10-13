import 'package:flutter/material.dart';
import 'package:godluckwiththat/app/constants.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/misc/custom_tooltip.dart';

class ActiveBuildingBlock extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;
  final String? tooltip;

  const ActiveBuildingBlock({
    required this.child,
    this.width = Constants.BUILDING_BLOCK_WIDTH,
    this.height = Constants.BUILDING_BLOCK_HEIGHT,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Palette.backgroundCardBlock,
        border: Border.all(
          width: 2,
          color: Palette.borderHighlight,
        ),
      ),
      child: Material(
        color: Palette.transparent,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: child,
            ),
            if (tooltip != null)
              Align(
                alignment: Alignment.topRight,
                child: NewTooltip.uppercase(
                  content: tooltip!,
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(
                      Icons.info_outline,
                      color: Palette.iconLevel2,
                      size: 15,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
