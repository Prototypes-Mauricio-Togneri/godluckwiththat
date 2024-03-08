import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/buildings/producers/producer.dart';
import 'package:godluckwiththat/utils/formatter.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/buttons/upgrade_building_button.dart';
import 'package:godluckwiththat/widgets/images/image_asset.dart';
import 'package:godluckwiththat/widgets/images/image_block.dart';
import 'package:godluckwiththat/widgets/labels/label.dart';
import 'package:godluckwiththat/widgets/selectors/workers_selector.dart';

class ProducerBlock extends StatelessWidget {
  final Producer producer;

  const ProducerBlock(this.producer);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LeftSection(producer),
          Expanded(
            child: MiddleSection(producer),
          ),
          RightSection(producer),
        ],
      ),
    );
  }
}

class LeftSection extends StatelessWidget {
  final Producer producer;

  const LeftSection(this.producer);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ImageBlock(
          path: producer.buildingType.sprite,
          size: 40,
        ),
        const HBox(15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Label(
                  text: 'LEVEL',
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
                      text: producer.level.toString(),
                      color: Palette.white,
                      align: TextAlign.center,
                      size: 8,
                    ),
                  ),
                ),
              ],
            ),
            const VBox(5),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ImageAsset(
                  path: producer.resourceType.sprite,
                  size: 18,
                ),
                const HBox(10),
                Label(
                  text: '${Formatter.production(producer.production)}/s',
                  color: (producer.production == 0)
                      ? Palette.error
                      : Palette.black,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class MiddleSection extends StatelessWidget {
  final Producer producer;

  const MiddleSection(this.producer);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: WorkersSelector(
        building: producer,
        size: 20,
      ),
    );
  }
}

class RightSection extends StatelessWidget {
  final Producer producer;

  const RightSection(this.producer);

  @override
  Widget build(BuildContext context) {
    return UpgradeBuildingButton(producer);
  }
}
