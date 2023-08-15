import 'package:flutter/material.dart';
import 'package:godluckwiththat/states/game_state.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/label.dart';

class ResearchView extends StatelessWidget {
  final GameState state;

  const ResearchView(this.state);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Label(
        text: 'RESEARCH',
        color: Palette.white,
        size: 40,
      ),
    );
  }
}
