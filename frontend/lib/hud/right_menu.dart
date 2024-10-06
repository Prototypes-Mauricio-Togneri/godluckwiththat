import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/states/game_state.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/labels/label.dart';

class RightMenu extends StatelessWidget {
  final GameState state;

  const RightMenu(this.state);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          const RightMenuTitle(),
          const HorizontalDivider(
            color: Palette.divider1,
            height: 1,
          ),
          RightMenuRow(
            text: 'Raid attack in 12:34',
            onPressed: state.onUpcoming,
          ),
          RightMenuRow(
            text: 'Challenge ending in 34:56',
            onPressed: state.onUpcoming,
          ),
          RightMenuRow(
            text: 'Research finishing in 34:56',
            onPressed: state.onUpcoming,
          ),
        ],
      ),
    );
  }
}

class RightMenuTitle extends StatelessWidget {
  const RightMenuTitle();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      width: double.infinity,
      padding: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xff7a5e00).withAlpha(150),
            Palette.backgroundTransparent1,
          ],
        ),
      ),
      child: const Align(
        alignment: Alignment.centerLeft,
        child: Label(
          text: 'Upcoming',
          weight: FontWeight.bold,
        ),
      ),
    );
  }
}

class RightMenuRow extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const RightMenuRow({
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: Palette.backgroundTransparent2,
        child: InkWell(
          hoverColor: Palette.backgroundTransparent1.withAlpha(50),
          onTap: onPressed,
          child: Container(
            height: 35,
            padding: const EdgeInsets.all(10),
            child: Label(text: text),
          ),
        ),
      ),
    );
  }
}
