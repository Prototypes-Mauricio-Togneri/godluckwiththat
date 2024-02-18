import 'package:flutter/material.dart';
import 'package:godluckwiththat/states/game_state.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/label.dart';

class UnitsView extends StatelessWidget {
  final GameState state;

  const UnitsView(this.state);

  @override
  Widget build(BuildContext context) {
    return const Label(
      text: 'UNITS',
      color: Palette.black,
    );
  }
}
