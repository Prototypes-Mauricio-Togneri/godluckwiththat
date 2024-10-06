import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/colony.dart';
import 'package:godluckwiththat/types/building_type.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/blocks/active_building_block.dart';
import 'package:godluckwiththat/widgets/buttons/create_building_button.dart';
import 'package:godluckwiththat/widgets/images/image_block.dart';
import 'package:godluckwiththat/widgets/labels/label.dart';

class CreateBuildingBlock extends StatelessWidget {
  final Colony colony;
  final BuildingType buildingType;

  const CreateBuildingBlock({
    required this.colony,
    required this.buildingType,
  });

  @override
  Widget build(BuildContext context) {
    return ActiveBuildingBlock(
      onSelected: () {
        print(buildingType);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          TopSection(buildingType),
          const Spacer(),
          BottomSection(
            colony: colony,
            buildingType: buildingType,
          ),
        ],
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
          text: buildingType.name,
          color: Palette.black,
          weight: FontWeight.bold,
          size: 16,
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
  final Colony colony;
  final BuildingType buildingType;

  const BottomSection({
    required this.colony,
    required this.buildingType,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CreateBuildingButton(
        colony: colony,
        buildingType: buildingType,
      ),
    );
  }
}
