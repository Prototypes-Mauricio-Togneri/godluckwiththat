import 'package:flutter/material.dart';
import 'package:tensionplanet/game/game_component.dart';
import 'package:tensionplanet/game/game_state.dart';
import 'package:tensionplanet/utils/palette.dart';
import 'package:tensionplanet/widgets/label.dart';

class VillageSwitcher extends StatelessWidget {
  final GameComponent game;
  final GameState state;
  
  const VillageSwitcher({
    required this.game,
    required this.state,
  });

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
