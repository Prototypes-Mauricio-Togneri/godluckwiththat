import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/buildings/producers/producer.dart';
import 'package:godluckwiththat/states/game_state.dart';
import 'package:godluckwiththat/widgets/producer_block.dart';
import 'package:godluckwiththat/widgets/resources_header.dart';

class ResourcesView extends StatelessWidget {
  final GameState state;

  const ResourcesView(this.state);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ResourcesHeader(state),
        for (final Producer producer in state.colony.producers)
          ProducerBlock(producer),
      ],
    );
  }
}
