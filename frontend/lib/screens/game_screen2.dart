import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:tensionnode/engine/game.dart';
import 'package:tensionnode/services/palette.dart';
import 'package:tensionnode/states/game_state.dart';

class GameScreen2 extends StatelessWidget {
  final GameState state;

  const GameScreen2(this.state);

  factory GameScreen2.instance() => GameScreen2(GameState());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.black,
      body: GameWidget(game: MyGame()),
    );
  }
}

class ScreenLayout extends StatelessWidget {
  final GameState state;

  const ScreenLayout(this.state);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        color: Colors.red,
        width: 200,
        height: 50,
      ),
    );
  }
}
