import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/buildings/consumers/headquarters.dart';
import 'package:godluckwiththat/states/game_state.dart';
import 'package:godluckwiththat/widgets/blocks/header_block.dart';
import 'package:godluckwiththat/widgets/blocks/headquarters_block.dart';

class HeadquartersView extends StatelessWidget {
  final GameState state;

  const HeadquartersView(this.state);

  @override
  Widget build(BuildContext context) {
    final List<Headquarters> headquarters =
        state.colony.buildingsByType(Headquarters);

    return Column(
      children: [
        HeaderBlock(state),
        HeadquartersBlock(headquarters[0]),
      ],
    );
  }
}
