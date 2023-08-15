import 'package:flutter/material.dart';
import 'package:godluckwiththat/states/game_state.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/label.dart';

class FoodView extends StatelessWidget {
  final GameState state;

  const FoodView(this.state);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Label(
        text: 'FOOD',
        color: Palette.white,
        size: 40,
      ),
    );
  }
}
