import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/buildings/consumers/consumer.dart';
import 'package:godluckwiththat/models/buildings/consumers/headquarters.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/buttons/train_unit_button.dart';
import 'package:godluckwiththat/widgets/buttons/upgrade_building_button.dart';

class HeadquartersBlock extends StatelessWidget {
  final Headquarters headquarters;

  const HeadquartersBlock(this.headquarters);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Palette.producerBlock,
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          //Header(consumer),
          //const VBox(10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LeftSection(headquarters),
              const Spacer(),
              RightSection(headquarters),
            ],
          ),
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
