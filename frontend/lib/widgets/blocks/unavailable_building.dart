import 'package:flutter/material.dart';
import 'package:godluckwiththat/app/constants.dart';
import 'package:godluckwiththat/types/building_type.dart';
import 'package:godluckwiththat/utils/palette.dart';

class UnavailableBuildingBlock extends StatelessWidget {
  final BuildingType buildingType;

  const UnavailableBuildingBlock(this.buildingType);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Constants.BUILDING_BLOCK_WIDTH,
      height: Constants.BUILDING_BLOCK_HEIGHT,
      color: Palette.backgroundBuildingBlock,
      padding: const EdgeInsets.all(10),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [],
      ),
    );
  }
}
