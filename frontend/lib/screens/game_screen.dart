import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gatewayguardians/game/game_state.dart';
import 'package:gatewayguardians/hud/left_menu.dart';
import 'package:gatewayguardians/json/json_match.dart';
import 'package:gatewayguardians/utils/palette.dart';

class GameScreen extends StatelessWidget {
  final GameState state;

  const GameScreen(this.state);

  factory GameScreen.instance(JsonMatch jsonMatch) {
    final GameState state = GameState(jsonMatch);

    return GameScreen(state);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        state.onPop();
        return false;
      },
      child: CustomStatusBar(
        style: SystemUiOverlayStyle.light,
        statusBarColor: Palette.grey,
        child: SafeArea(
          child: Scaffold(
            body: StateProvider<GameState>(
              state: state,
              builder: (context, state) => RawKeyboardListener(
                autofocus: true,
                focusNode: state.focusNode,
                onKey: state.onKey,
                child: Row(
                  children: [
                    LeftMenu(state),
                    const Expanded(child: Empty()),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
