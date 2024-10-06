import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/buildings/building.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/blocks/active_building_block.dart';
import 'package:godluckwiththat/widgets/buttons/upgrade_building_button.dart';
import 'package:godluckwiththat/widgets/images/image_block.dart';
import 'package:godluckwiththat/widgets/labels/label.dart';

class PassiveBuildingBlock extends StatelessWidget {
  final Building building;

  const PassiveBuildingBlock(this.building);

  @override
  Widget build(BuildContext context) {
    return ActiveBuildingBlock(
      onSelected: () {
        print(building);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          TopSection(building),
          const Spacer(),
          BottomSection(building),
        ],
      ),
    );
  }
}

class TopSection extends StatelessWidget {
  final Building building;

  const TopSection(this.building);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Label(
          text: building.buildingType.name,
          color: Palette.textLevel2,
          weight: FontWeight.bold,
          size: 14,
        ),
        const VBox(10),
        ImageBlock(
          path: building.buildingType.sprite,
          size: 100,
        ),
      ],
    );
  }
}

class BottomSection extends StatelessWidget {
  final Building building;

  const BottomSection(this.building);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: UpgradeBuildingButton(building),
    );
  }
}
