import 'package:dafluta/dafluta.dart';
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
      width: double.infinity,
      height: 35,
      color: Palette.backgroundTopBar.withAlpha(200),
      child: Row(
        children: [
          const HBox(5),
          SeasonIndicator(state),
        ],
      ),
    );
  }
}

class TopBarContainer extends StatelessWidget {
  final double size;
  final Widget child;

  const TopBarContainer({
    required this.size,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25,
      width: size,
      color: Palette.backgroundTopBarContainer,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: child,
        ),
      ),
    );
  }
}

class SeasonIndicator extends StatelessWidget {
  final GameState state;

  const SeasonIndicator(this.state);

  @override
  Widget build(BuildContext context) {
    return const TopBarContainer(
      size: 80,
      child: Row(
        children: [
          Icon(
            Icons.wb_sunny,
            color: Colors.orange,
            size: 12,
          ),
          HBox(5),
          Label(text: 'Summer'),
        ],
      ),
    );
  }
}
