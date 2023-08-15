import 'package:flutter/material.dart';
import 'package:godluckwiththat/states/game_state.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/label.dart';

class FaithView extends StatelessWidget {
  final GameState state;

  const FaithView(this.state);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Label(
        text: 'FAITH',
        color: Palette.white,
        size: 40,
      ),
    );
  }
}
