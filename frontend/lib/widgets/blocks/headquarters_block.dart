import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/buildings/consumers/consumer.dart';
import 'package:godluckwiththat/models/buildings/consumers/headquarters.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/blocks/active_building_block.dart';
import 'package:godluckwiththat/widgets/buttons/train_unit_button.dart';
import 'package:godluckwiththat/widgets/buttons/upgrade_building_button.dart';
import 'package:godluckwiththat/widgets/images/image_block.dart';
import 'package:godluckwiththat/widgets/labels/label.dart';

class HeadquartersBlock extends StatelessWidget {
  final Headquarters headquarters;

  const HeadquartersBlock(this.headquarters);

  @override
  Widget build(BuildContext context) {
    return ActiveBuildingBlock(
      onSelected: () {
        print(headquarters);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          TopSection(headquarters),
          const VBox(10),
          MiddleSection(headquarters),
          const Spacer(),
          BottomSection(headquarters),
        ],
      ),
    );
  }
}

class TopSection extends StatelessWidget {
  final Consumer consumer;

  const TopSection(this.consumer);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Label(
          text: consumer.buildingType.name,
          color: Palette.black,
          weight: FontWeight.bold,
          size: 16,
        ),
        const VBox(10),
        ImageBlock(
          path: consumer.buildingType.sprite,
          size: 100,
        ),
      ],
    );
  }
}

class MiddleSection extends StatelessWidget {
  final Consumer consumer;

  const MiddleSection(this.consumer);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TrainUnitButton(consumer),
    );
  }
}

class BottomSection extends StatelessWidget {
  final Consumer consumer;

  const BottomSection(this.consumer);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: UpgradeBuildingButton(consumer),
    );
  }
}
