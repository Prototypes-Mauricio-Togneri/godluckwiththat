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
        color: Palette.backgroundBuildingBlock,
        border: Border.all(
          width: 2,
          color: Palette.borderHighlight,
        ),
      ),
      child: Material(
        color: Palette.transparent,
        child: InkWell(
          onTap: onSelected,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: child,
              ),
              if (onSelected != null)
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Icon(
                      Icons.info_rounded,
                      color: Palette.iconLevel1,
                      size: 15,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
