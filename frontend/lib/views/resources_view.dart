import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/buildings/producers/producer.dart';
import 'package:godluckwiththat/states/game_state.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/blocks/header_block.dart';
import 'package:godluckwiththat/widgets/blocks/producer_block.dart';
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
          title: 'FARM',
          producers: state.colony.producers,
        ),
      ],
    );
  }
}

class ProducerList extends StatefulWidget {
  final String title;
  final List<Producer> producers;

  const ProducerList({
    required this.title,
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
          headerBuilder: (context, isExpanded) => Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Label(
                text: widget.title,
                color: Palette.black,
                weight: FontWeight.bold,
                size: 20,
              ),
            ),
          ),
          body: Column(
            children: [
              for (final Producer producer in widget.producers)
                ProducerBlock(producer),
            ],
          ),
        ),
      ],
    );
  }
}
