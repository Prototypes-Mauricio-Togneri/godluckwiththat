import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/buildings/consumers/consumer.dart';
import 'package:godluckwiththat/utils/formatter.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/buttons/train_unit_button.dart';
import 'package:godluckwiththat/widgets/buttons/upgrade_building_button.dart';
import 'package:godluckwiththat/widgets/labels/label.dart';
import 'package:godluckwiththat/widgets/labels/resource_indicator.dart';

class HeadquartersBlock extends StatelessWidget {
  final Consumer consumer;

  const HeadquartersBlock(this.consumer);

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
              Expanded(
                child: MiddleSection(consumer),
              ),
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
          size: 20,
        ),
        const HBox(15),
        Container(
          width: 20,
          height: 20,
          decoration: const BoxDecoration(
            color: Palette.lightGrey,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Label(
              text: consumer.level.toString(),
              color: Palette.white,
              align: TextAlign.center,
              size: 10,
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
    return ResourceIndicator(
      sprite: consumer.resourceType.sprite,
      value:
          '${Formatter.resource(consumer.resources)}/${Formatter.resource(consumer.maxResourceCapacity)}',
      textColor: (consumer.isEmptyOfResources || consumer.isFullOfResources)
          ? Palette.error
          : Palette.black,
      textSize: 20,
      iconSize: 17,
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

class RightSection extends StatelessWidget {
  final Consumer consumer;

  const RightSection(this.consumer);

  @override
  Widget build(BuildContext context) {
    return UpgradeBuildingButton(consumer);
  }
}
