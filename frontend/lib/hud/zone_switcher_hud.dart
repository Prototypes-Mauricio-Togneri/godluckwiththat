import 'package:flutter/material.dart';
import 'package:tensionplanet/game/game_state.dart';
import 'package:tensionplanet/utils/palette.dart';
import 'package:tensionplanet/widgets/label.dart';

class ZoneSwitcherHud extends StatelessWidget {
  final GameState state;

  const ZoneSwitcherHud(this.state);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        color: Palette.lightGrey,
        padding: const EdgeInsets.all(5),
        child: const Label(text: 'Settlement'),
      ),
    );
  }
}
