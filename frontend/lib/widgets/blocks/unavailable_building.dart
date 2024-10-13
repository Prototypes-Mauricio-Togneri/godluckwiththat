import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/types/building_type.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/blocks/active_building_block.dart';
import 'package:godluckwiththat/widgets/images/image_block.dart';
import 'package:godluckwiththat/widgets/images/image_grayscale.dart';
import 'package:godluckwiththat/widgets/labels/label.dart';

class UnavailableBuildingBlock extends StatelessWidget {
  final BuildingType buildingType;

  const UnavailableBuildingBlock(this.buildingType);

  @override
  Widget build(BuildContext context) {
    return Grayscale(
      child: ActiveBuildingBlock(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            TopSection(buildingType),
            const Spacer(),
            BottomSection(buildingType),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class TopSection extends StatelessWidget {
  final BuildingType buildingType;

  const TopSection(this.buildingType);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Label(
          text: buildingType.localized,
          color: Palette.textLevel2,
          weight: FontWeight.bold,
          size: 14,
        ),
        const VBox(10),
        ImageBlock(
          path: buildingType.sprite,
          size: 100,
        ),
      ],
    );
  }
}

class BottomSection extends StatelessWidget {
  final BuildingType buildingType;

  const BottomSection(this.buildingType);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Icon(
            Icons.lock,
            color: Palette.iconDisabled,
            size: 80,
          ),
          const VBox(10),
          Label(
            text: 'Requires ${buildingType.requires.localized}',
            color: Palette.textLevel2,
          ),
        ],
      ),
    );
  }
}
