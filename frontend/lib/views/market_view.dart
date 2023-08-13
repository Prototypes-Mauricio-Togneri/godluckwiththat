import 'package:flutter/material.dart';
import 'package:gatewayguardians/states/game_state.dart';
import 'package:gatewayguardians/utils/palette.dart';
import 'package:gatewayguardians/widgets/label.dart';

class MarketView extends StatelessWidget {
  final GameState state;

  const MarketView(this.state);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Label(
        text: 'MARKET',
        color: Palette.white,
        size: 40,
      ),
    );
  }
}
