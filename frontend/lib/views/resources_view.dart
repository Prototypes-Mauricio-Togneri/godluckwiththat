import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/buildings/producers/producer.dart';
import 'package:godluckwiththat/states/game_state.dart';
import 'package:godluckwiththat/types/building_type.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/blocks/header_block.dart';
import 'package:godluckwiththat/widgets/blocks/producer_block.dart';
import 'package:godluckwiththat/widgets/buttons/primary_button.dart';
import 'package:godluckwiththat/widgets/labels/label.dart';

class ResourcesView extends StatelessWidget {
  final GameState state;

  const ResourcesView(this.state);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HeaderBlock(state),
        ProducerList(
          buildingType: BuildingType.farm,
          producers: state.colony.producers,
        ),
        ProducerList(
          buildingType: BuildingType.woodcutter,
          producers: state.colony.producers,
        ),
        ProducerList(
          buildingType: BuildingType.quarry,
          producers: state.colony.producers,
        ),
      ],
    );
  }
}

class ProducerList extends StatefulWidget {
  final BuildingType buildingType;
  final List<Producer> producers;

  const ProducerList({
    required this.buildingType,
    required this.producers,
  });

  @override
  State<ProducerList> createState() => _Content();
}

class _Content extends State<ProducerList> {
  bool expanded = true;

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      elevation: 0,
      dividerColor: Palette.transparent,
      materialGapSize: 0,
      expandedHeaderPadding: const EdgeInsets.all(0),
      expansionCallback: (index, isExpanded) {
        setState(() {
          expanded = isExpanded;
        });
      },
      children: [
        ExpansionPanel(
          backgroundColor: Palette.lightGrey,
          isExpanded: expanded,
          canTapOnHeader: true,
          headerBuilder: (context, isExpanded) =>
              ProducerListHeader(widget.buildingType.name),
          body: ProducerListContent(widget.producers
              .where((e) => e.buildingType == widget.buildingType)
              .toList()),
        ),
      ],
    );
  }
}

class ProducerListHeader extends StatelessWidget {
  final String title;

  const ProducerListHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Label(
          text: title,
          color: Palette.black,
          weight: FontWeight.bold,
          size: 20,
        ),
      ),
    );
  }
}

class ProducerListContent extends StatelessWidget {
  final List<Producer> producers;

  const ProducerListContent(this.producers);

  @override
  Widget build(BuildContext context) {
    if (producers.isEmpty) {
      return Container(
        color: Palette.producerBlock,
        padding: const EdgeInsets.all(15),
        child: Center(
          child: PrimaryButton(
            text: 'BUILD',
            color: Palette.success,
            onPressed: () {},
            icon: Icons.construction,
            textSize: 20,
            expand: false,
          ),
        ),
      );
    } else {
      return Column(
        children: [
          for (final Producer producer in producers) ProducerBlock(producer),
        ],
      );
    }
  }
}
