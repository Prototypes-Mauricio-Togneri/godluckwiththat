import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/buildings/building.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/buttons/upgrade_building_button.dart';
import 'package:godluckwiththat/widgets/images/image_block.dart';
import 'package:godluckwiththat/widgets/labels/label.dart';

class PassiveBuildingBlock extends StatelessWidget {
  final Building building;

  const PassiveBuildingBlock(this.building);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Palette.producerBlock,
        border: Border(
          bottom: BorderSide(
            width: 0.5,
            color: Palette.lightGrey,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          LeftSection(building),
          const Spacer(),
          const Spacer(),
          RightSection(building),
        ],
      ),
    );
  }
}

class LeftSection extends StatelessWidget {
  final Building building;

  const LeftSection(this.building);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ImageBlock(
          path: building.buildingType.sprite,
          size: 80,
        ),
        const HBox(15),
        Label(
          text: building.buildingType.name,
          color: Palette.black,
          weight: FontWeight.bold,
          size: 14,
        ),
      ],
    );
  }
}

class RightSection extends StatelessWidget {
  final Building building;

  const RightSection(this.building);

  @override
  Widget build(BuildContext context) {
    return UpgradeBuildingButton(building);
  }
}
