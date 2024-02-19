import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/buildings/producers/producer.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/buttons/upgrade_building_button.dart';
import 'package:godluckwiththat/widgets/labels/label.dart';
import 'package:godluckwiththat/widgets/misc/image_asset.dart';
import 'package:godluckwiththat/widgets/selectors/workers_selector.dart';

class ProducerBlock extends StatelessWidget {
  final Producer producer;

  const ProducerBlock(this.producer);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Palette.producerBlock,
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Header(producer),
          const VBox(10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LeftSection(producer),
              Expanded(
                child: MiddleSection(producer),
              ),
              RightSection(producer),
            ],
          ),
        ],
      ),
    );
  }
}

class Header extends StatelessWidget {
  final Producer producer;

  const Header(this.producer);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Label(
          text: 'LEVEL',
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
              text: producer.level.toString(),
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
  final Producer producer;

  const LeftSection(this.producer);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ImageAsset(
          path: producer.resourceType.sprite,
          size: 18,
        ),
        const HBox(10),
        Label(
          text: '${producer.production}/day',
          color: (producer.production == 0) ? Palette.error : Palette.black,
          size: 20,
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
