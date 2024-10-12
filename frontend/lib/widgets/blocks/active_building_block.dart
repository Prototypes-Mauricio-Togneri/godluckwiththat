import 'package:flutter/material.dart';
import 'package:godluckwiththat/app/constants.dart';
import 'package:godluckwiththat/utils/palette.dart';

class ActiveBuildingBlock extends StatelessWidget {
  final Widget child;
  final VoidCallback? onSelected;

  const ActiveBuildingBlock({
    required this.child,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Constants.BUILDING_BLOCK_WIDTH,
      height: Constants.BUILDING_BLOCK_HEIGHT,
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
            if (onSelected != null)
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  child: IconButton(
                    iconSize: 15,
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(),
                    splashRadius: 20,
                    icon: const Icon(
                      Icons.info_outline,
                      color: Palette.iconLevel2,
                      size: 15,
                    ),
                    onPressed: onSelected,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
