import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:tensionnode/engine/game.dart';
import 'package:tensionnode/engine/game_state.dart';
import 'package:tensionnode/services/palette.dart';

class GameScreen extends StatelessWidget {
  final GameState state;

  const GameScreen(this.state);

  factory GameScreen.instance() => GameScreen(GameState());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.black,
      body: GameWidget(game: MyGame()),
    );
  }
}
