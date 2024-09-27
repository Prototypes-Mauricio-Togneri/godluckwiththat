import 'package:flutter/material.dart';
import 'package:godluckwiththat/states/game_state.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/labels/label.dart';

class RightMenu extends StatelessWidget {
  final GameState state;

  const RightMenu(this.state);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Palette.black,
      child: const Label(text: 'RIGHT MENU'),
    );
  }
}
