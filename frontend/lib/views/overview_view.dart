import 'package:flutter/material.dart';
import 'package:godluckwiththat/states/game_state.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/labels/label.dart';

class OverviewView extends StatelessWidget {
  final GameState state;

  const OverviewView(this.state);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Label(
        text: 'OVERVIEW',
        color: Palette.black,
      ),
    );
  }
}
