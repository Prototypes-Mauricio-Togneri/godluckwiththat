import 'package:flutter/material.dart';
import 'package:godluckwiththat/states/game_state.dart';
import 'package:godluckwiththat/widgets/blocks/town_center_block.dart';

class TownCenterView extends StatelessWidget {
  final GameState state;

  const TownCenterView(this.state);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TownCenterBlock(state.colony.townCenter),
      ],
    );
  }
}
