import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:tensionnode/services/palette.dart';
import 'package:tensionnode/states/game_state.dart';

class Hud extends StatelessWidget {
  final GameState state;

  const Hud(this.state);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        height: 50,
        padding: const EdgeInsets.all(5),
        color: Palette.hudBackground,
        child: Row(
          children: [
            MainMenuButton(state),
            const Spacer(),
            ResourceIndicator(
              name: 'Copper',
              value: state.headquarters.resource1,
            ),
            const HBox(30),
            ResourceIndicator(
              name: 'Iron',
              value: state.headquarters.resource2,
            ),
            const HBox(30),
            ResourceIndicator(
              name: 'Titanium',
              value: state.headquarters.resource3,
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class MainMenuButton extends StatelessWidget {
  final GameState state;

  const MainMenuButton(this.state);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Palette.transparent,
      child: InkWell(
        onTap: state.onMainMenu,
        borderRadius: BorderRadius.circular(5),
        child: Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Palette.hudButton,
            borderRadius: BorderRadius.circular(5),
          ),
          child: const Center(
            child: Icon(
              Icons.menu,
              color: Palette.white,
            ),
          ),
        ),
      ),
    );
  }
}

class ResourceIndicator extends StatelessWidget {
  final String name;
  final num value;

  const ResourceIndicator({
    required this.name,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          name,
          style: const TextStyle(
            color: Palette.white,
            fontSize: 15,
          ),
        ),
        const HBox(10),
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Palette.hudResourceIndicator,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: Text(
              value.toInt().toString(),
              style: const TextStyle(
                color: Palette.white,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
