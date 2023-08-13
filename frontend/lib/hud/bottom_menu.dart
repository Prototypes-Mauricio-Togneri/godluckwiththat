import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:gatewayguardians/states/game_state.dart';
import 'package:gatewayguardians/utils/palette.dart';
import 'package:gatewayguardians/widgets/label.dart';

class BottomMenu extends StatelessWidget {
  final GameState state;

  const BottomMenu(this.state);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FaithBlock(state),
      ],
    );
  }
}

class FaithBlock extends StatelessWidget {
  final GameState state;

  const FaithBlock(this.state);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: Palette.transparent,
        border: Border.all(
          width: 3,
          color: Palette.lightGrey,
        ),
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          VBox(10),
          Label(
            text: 'Faith: 50/100',
            color: Palette.white,
            size: 35,
          ),
          VBox(10),
          Label(
            text: 'Days left: 30',
            color: Palette.white,
            size: 35,
          ),
          VBox(10),
        ],
      ),
    );
  }
}
