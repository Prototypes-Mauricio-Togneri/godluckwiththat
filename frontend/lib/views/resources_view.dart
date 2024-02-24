import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/extensions/resource_map_extension.dart';
import 'package:godluckwiththat/models/buildings/producers/producer.dart';
import 'package:godluckwiththat/models/colony.dart';
import 'package:godluckwiththat/states/game_state.dart';
import 'package:godluckwiththat/types/building_type.dart';
import 'package:godluckwiththat/utils/formatter.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/blocks/header_block.dart';
import 'package:godluckwiththat/widgets/blocks/producer_block.dart';
import 'package:godluckwiththat/widgets/buttons/primary_button.dart';
import 'package:godluckwiththat/widgets/labels/label.dart';
import 'package:godluckwiththat/widgets/labels/resource_indicator.dart';

class ResourcesView extends StatelessWidget {
  final GameState state;

  const ResourcesView(this.state);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HeaderBlock(state),
        ProducerList(
          colony: state.colony,
          buildingType: BuildingType.farm,
          producers: state.colony.producers,
        ),
        ProducerList(
          colony: state.colony,
          buildingType: BuildingType.woodcutter,
          producers: state.colony.producers,
        ),
        ProducerList(
          colony: state.colony,
          buildingType: BuildingType.quarry,
          producers: state.colony.producers,
        ),
      ],
    );
  }
}

class ProducerList extends StatefulWidget {
  final Colony colony;
  final BuildingType buildingType;
  final List<Producer> producers;

  const ProducerList({
    required this.colony,
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
    final List<Producer> list = widget.producers
        .where((e) => e.buildingType == widget.buildingType)
        .toList();

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
          headerBuilder: (context, isExpanded) => ProducerListHeader(
              '${widget.buildingType.name} (${list.length})'),
          body: ProducerListContent(
            colony: widget.colony,
            buildingType: widget.buildingType,
            producers: list,
          ),
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
          size: 14,
        ),
      ),
    );
  }
}

class ProducerListContent extends StatelessWidget {
  final Colony colony;
  final BuildingType buildingType;
  final List<Producer> producers;

  const ProducerListContent({
    required this.colony,
    required this.buildingType,
    required this.producers,
  });

  @override
  Widget build(BuildContext context) {
    if (producers.isEmpty) {
      return BuildProducerButton(
        colony: colony,
        buildingType: buildingType,
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

class BuildProducerButton extends StatelessWidget {
  final Colony colony;
  final BuildingType buildingType;

  const BuildProducerButton({
    required this.colony,
    required this.buildingType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Palette.producerBlock,
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          PrimaryButton(
            text: 'BUILD',
            color: Palette.success,
            onPressed: colony.canBuild(buildingType)
                ? () => colony.build(buildingType)
                : null,
            icon: Icons.construction,
            textSize: 14,
            expand: false,
          ),
          const VBox(10),
          for (final ResourceMapEntry resource in buildingType.cost(1).entries)
            ResourceIndicator(
              sprite: resource.key.sprite,
              value: Formatter.resource(resource.value),
              textColor: colony.resourceInventory.hasItem(resource)
                  ? Palette.black
                  : Palette.error,
              textSize: 15,
              iconSize: 15,
            ),
        ],
      ),
    );
  }
}
