import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/buildings/consumers/consumer.dart';
import 'package:godluckwiththat/models/buildings/consumers/headquarters.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/buttons/train_unit_button.dart';
import 'package:godluckwiththat/widgets/buttons/upgrade_building_button.dart';
import 'package:godluckwiththat/widgets/images/image_block.dart';

class HeadquartersBlock extends StatelessWidget {
  final Headquarters headquarters;

  const HeadquartersBlock(this.headquarters);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Palette.producerBlock,
      padding: const EdgeInsets.all(15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          LeftSection(headquarters),
          const Spacer(),
          MiddleSection(headquarters),
          const Spacer(),
          RightSection(headquarters),
        ],
      ),
    );
  }
}

class LeftSection extends StatelessWidget {
  final Consumer consumer;

  const LeftSection(this.consumer);

  @override
  Widget build(BuildContext context) {
    return ImageBlock(
      path: consumer.buildingType.sprite,
      size: 70,
    );
  }
}

class MiddleSection extends StatelessWidget {
  final Consumer consumer;

  const MiddleSection(this.consumer);

  @override
  Widget build(BuildContext context) {
    return TrainUnitButton(consumer);
  }
}

class RightSection extends StatelessWidget {
  final Consumer consumer;

  const RightSection(this.consumer);

  @override
  Widget build(BuildContext context) {
    return UpgradeBuildingButton(consumer);
  }
}
