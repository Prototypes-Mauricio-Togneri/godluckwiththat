import 'package:flutter/material.dart';
import 'package:godluckwiththat/states/game_state.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/label.dart';

class WaterView extends StatelessWidget {
  final GameState state;

  const WaterView(this.state);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Label(
        text: 'WATER',
        color: Palette.white,
        size: 40,
      ),
    );
  }
}
