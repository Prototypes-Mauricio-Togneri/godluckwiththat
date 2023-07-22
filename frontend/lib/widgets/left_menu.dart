import 'package:flutter/material.dart';
import 'package:gatewayguardians/game/game_state.dart';
import 'package:gatewayguardians/utils/palette.dart';

class LeftMenu extends StatelessWidget {
  final GameState state;

  const LeftMenu(this.state);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Palette.success,
      width: 300,
      height: double.infinity,
    );
  }
}
