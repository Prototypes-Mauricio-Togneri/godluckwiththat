import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/extensions/resource_map_extension.dart';
import 'package:godluckwiththat/models/buildings/trainers/trainer.dart';
import 'package:godluckwiththat/models/resource.dart';
import 'package:godluckwiththat/utils/formatter.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/add_remove_button.dart';
import 'package:godluckwiththat/widgets/label.dart';
import 'package:godluckwiththat/widgets/resource_indicator.dart';

class TrainerBlock extends StatelessWidget {
  final Trainer trainer;

  const TrainerBlock(this.trainer);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Palette.producerBlock,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Header(trainer),
          const VBox(10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LeftSection(trainer),
              Expanded(
                child: MiddleSection(trainer),
              ),
              RightSection(trainer),
            ],
          ),
        ],
      ),
    );
  }
}

class Header extends StatelessWidget {
  final Trainer trainer;

  const Header(this.trainer);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Label(
          text: trainer.buildingType.name,
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
              text: trainer.level.toString(),
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
  final Trainer trainer;

  const LeftSection(this.trainer);

  @override
  Widget build(BuildContext context) {
    return ResourceIndicator(
      sprite: trainer.resourceType.sprite,
      value:
          '${Formatter.resource(trainer.resources)}/${Formatter.resource(trainer.maxResourceCapacity)}',
      textColor: Palette.black,
      textSize: 20,
      iconSize: 17,
    );
  }
}

class MiddleSection extends StatelessWidget {
  final Trainer trainer;

  const MiddleSection(this.trainer);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AddRemoveButton.add(
        size: 40,
        onTap: trainer.canTrain ? trainer.train : null,
      ),
    );
  }
}

class RightSection extends StatelessWidget {
  final Trainer trainer;

  const RightSection(this.trainer);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40,
          height: 40,
          color: Palette.success,
          child: const Center(
            child: Icon(
              Icons.arrow_upward,
              color: Palette.white,
              size: 20,
            ),
          ),
        ),
        const VBox(5),
        for (final Resource resource in trainer.upgradeCost.resources())
          ResourceIndicator(
            sprite: resource.resourceType.sprite,
            value: Formatter.resource(resource.amount),
            textColor: Palette.black,
            textSize: 15,
            iconSize: 15,
          ),
      ],
    );
  }
}
