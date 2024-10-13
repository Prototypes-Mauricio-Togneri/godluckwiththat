import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/hud/bottom_menu.dart';
import 'package:godluckwiththat/hud/left_menu.dart';
import 'package:godluckwiththat/hud/right_menu.dart';
import 'package:godluckwiththat/hud/top_menu.dart';
import 'package:godluckwiththat/states/game_state.dart';
import 'package:godluckwiththat/utils/assets.dart';
import 'package:godluckwiththat/widgets/misc/game_loop.dart';

class GameScreen extends StatelessWidget {
  final GameState state;

  const GameScreen(this.state);

  factory GameScreen.instance() => GameScreen(GameState());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PopScope(
        canPop: false,
        child: GameLoop(
          state: state,
          content: GameContent(state),
        ),
      ),
    );
  }
}

class GameContent extends StatelessWidget {
  final GameState state;

  const GameContent(this.state);

  @override
  Widget build(BuildContext context) {
    return StateProvider<GameState>(
      state: state,
      builder: (context, state) => Stack(
        children: [
          MapView(state),
          Align(
            alignment: Alignment.topCenter,
            child: TopMenu(state),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: BottomMenu(state),
          ),
          if (state.colony.pastEvents.isNotEmpty)
            Align(
              alignment: Alignment.centerLeft,
              child: LeftMenu(state),
            ),
          if (state.colony.futureEvents.isNotEmpty)
            Align(
              alignment: Alignment.centerRight,
              child: RightMenu(state),
            ),
          if (state.hasWindow)
            Align(
              alignment: Alignment.center,
              child: state.currentWindow!,
            ),
        ],
      ),
    );
  }
}

class MapView extends StatelessWidget {
  final GameState state;

  const MapView(this.state);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Assets.IMAGES_BACKGROUNDS_BACKGROUND),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
