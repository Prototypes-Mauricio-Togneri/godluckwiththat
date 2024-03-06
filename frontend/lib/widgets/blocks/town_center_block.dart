import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/buildings/consumers/consumer.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/buttons/train_unit_button.dart';
import 'package:godluckwiththat/widgets/buttons/upgrade_building_button.dart';
import 'package:godluckwiththat/widgets/labels/label.dart';

class TownCenterBlock extends StatelessWidget {
  final Consumer consumer;

  const TownCenterBlock(this.consumer);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Palette.producerBlock,
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Header(consumer),
          const VBox(10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LeftSection(consumer),
              const Spacer(),
              RightSection(consumer),
            ],
          ),
        ],
      ),
    );
  }
}

class Header extends StatelessWidget {
  final Consumer consumer;

  const Header(this.consumer);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Label(
          text: consumer.buildingType.name,
          color: Palette.black,
          weight: FontWeight.bold,
        ),
        const HBox(5),
        Container(
          width: 14,
          height: 14,
          decoration: const BoxDecoration(
            color: Palette.lightGrey,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Label(
              text: consumer.level.toString(),
              color: Palette.white,
              align: TextAlign.center,
              size: 6,
            ),
          ),
        ),
      ],
    );
  }
}

class LeftSection extends StatelessWidget {
  final Consumer consumer;

  const LeftSection(this.consumer);

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
