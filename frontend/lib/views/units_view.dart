import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/buildings/trainers/trainer.dart';
import 'package:godluckwiththat/states/game_state.dart';
import 'package:godluckwiththat/widgets/resources_header.dart';
import 'package:godluckwiththat/widgets/trainer_block.dart';

class UnitsView extends StatelessWidget {
  final GameState state;

  const UnitsView(this.state);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ResourcesHeader(state),
        for (final Trainer trainer in state.colony.trainers)
          TrainerBlock(trainer),
      ],
    );
  }
}
