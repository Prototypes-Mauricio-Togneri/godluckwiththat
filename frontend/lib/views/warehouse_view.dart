import 'package:flutter/material.dart';
import 'package:gatewayguardians/states/game_state.dart';
import 'package:gatewayguardians/utils/palette.dart';
import 'package:gatewayguardians/widgets/label.dart';

class WarehouseView extends StatelessWidget {
  final GameState state;

  const WarehouseView(this.state);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Label(
        text: 'WAREHOUSE',
        color: Palette.white,
        size: 40,
      ),
    );
  }
}
