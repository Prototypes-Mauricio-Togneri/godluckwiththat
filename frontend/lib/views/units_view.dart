import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/buildings/trainers/trainer.dart';
import 'package:godluckwiththat/states/game_state.dart';
import 'package:godluckwiththat/widgets/blocks/header_block.dart';
import 'package:godluckwiththat/widgets/blocks/trainer_block.dart';

class UnitsView extends StatelessWidget {
  final GameState state;

  const UnitsView(this.state);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HeaderBlock(state),
        for (final Trainer trainer in state.colony.trainers)
          TrainerBlock(trainer),
      ],
    );
  }
}
