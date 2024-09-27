import 'package:flutter/material.dart';
import 'package:godluckwiththat/states/game_state.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/labels/label.dart';

class TopMenu extends StatelessWidget {
  final GameState state;

  const TopMenu(this.state);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Palette.black,
      child: const Label(text: 'TOP MENU'),
    );
  }
}
