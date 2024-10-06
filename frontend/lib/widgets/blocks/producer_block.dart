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
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Palette.producerBlock,
        border: Border.all(
          width: 2,
          color: Palette.borderHighlight,
        ),
      ),
      child: Material(
        color: Palette.transparent,
        child: InkWell(
          onTap: () {
            print(producer);
          },
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TopSection(producer),
                    const VBox(10),
                    MiddleSection(producer),
                    const VBox(15),
                    BottomSection(producer),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Icon(
                    Icons.info_rounded,
                    color: Palette.iconLevel2,
                    size: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TopSection extends StatelessWidget {
  final Producer producer;

  const TopSection(this.producer);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Label(
          text: producer.buildingType.name,
          color: Palette.black,
          weight: FontWeight.bold,
          size: 16,
        ),
        const VBox(10),
        ImageBlock(
          path: producer.buildingType.sprite,
          size: 100,
        ),
        const VBox(10),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ImageAsset(
              path: producer.resourceType.sprite,
              size: 20,
            ),
            const HBox(10),
            Label(
              text: '${Formatter.production(producer.production)}/s',
              color: (producer.production == 0) ? Palette.error : Palette.black,
              size: 14,
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

class BottomSection extends StatelessWidget {
  final Producer producer;

  const BottomSection(this.producer);

  @override
  Widget build(BuildContext context) {
    return UpgradeBuildingButton(producer);
  }
}
