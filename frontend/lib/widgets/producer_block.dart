import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/buildings/producers/producer.dart';
import 'package:godluckwiththat/types/resource_type.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/label.dart';
import 'package:godluckwiththat/widgets/resource_indicator.dart';
import 'package:godluckwiththat/widgets/workers_selector.dart';

class ProducerBlock extends StatelessWidget {
  final Producer producer;

  const ProducerBlock(this.producer);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Palette.producerBlock,
      margin: const EdgeInsets.all(10),
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
        Label(
          text: producer.buildingType.name,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ResourceIndicator(
          sprite: producer.resourceType.sprite,
          value: '${producer.resources}/${producer.capacity}',
          textColor: ((producer.resources == 0) ||
                  producer.resources >= producer.capacity)
              ? Palette.error
              : Palette.black,
          textSize: 20,
          iconSize: 17,
        ),
        const VBox(5),
        Label(
          text: '${producer.production}/day',
          color: (producer.production == 0) ? Palette.error : Palette.black,
          size: 15,
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
        ResourceIndicator(
          sprite: ResourceType.wood.sprite,
          value: '10',
          textColor: Palette.black,
          textSize: 15,
          iconSize: 15,
        ),
      ],
    );
  }
}
