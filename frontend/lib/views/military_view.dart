import 'package:flutter/material.dart';
import 'package:godluckwiththat/states/game_state.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/labels/label.dart';

class MilitaryView extends StatelessWidget {
  final GameState state;

  const MilitaryView(this.state);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Label(
        text: 'MILITARY',
        color: Palette.black,
      ),
    );
  }
}
