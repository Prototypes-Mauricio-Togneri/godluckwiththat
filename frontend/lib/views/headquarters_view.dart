import 'package:flutter/material.dart';
import 'package:gatewayguardians/states/game_state.dart';
import 'package:gatewayguardians/utils/palette.dart';
import 'package:gatewayguardians/widgets/label.dart';

class HeadquartersView extends StatelessWidget {
  final GameState state;

  const HeadquartersView(this.state);

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Label(
          text: 'TOWN CENTER',
          color: Palette.white,
          size: 40,
        ),
      ],
    );
  }
}
