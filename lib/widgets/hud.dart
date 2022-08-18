import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:tensionnode/services/palette.dart';
import 'package:tensionnode/states/game_state.dart';
import 'package:tensionnode/types/label.dart';
import 'package:tensionnode/types/resource_type.dart';

class Hud extends StatelessWidget {
  final GameState state;

  const Hud(this.state);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.all(5),
      color: Palette.hudBackground,
      child: Row(
        children: [
          MainMenuButton(state),
          const Spacer(),
          ResourceIndicator(
            icon: Icons.square,
            color: ResourceType.resource1.color,
            value: state.headquarters.resource1.toInt().toString(),
          ),
          const HBox(30),
          ResourceIndicator(
            icon: Icons.square,
            color: ResourceType.resource2.color,
            value: state.headquarters.resource2.toInt().toString(),
          ),
          const HBox(30),
          ResourceIndicator(
            icon: Icons.square,
            color: ResourceType.resource3.color,
            value: state.headquarters.resource3.toInt().toString(),
          ),
          const HBox(30),
          ResourceIndicator(
            icon: Icons.bolt,
            color: Palette.energy,
            value: '${state.energyConsumed} / ${state.energyProduced}',
          ),
          const Spacer(),
          RepairButton(state),
        ],
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

class RepairButton extends StatelessWidget {
  final GameState state;

  const RepairButton(this.state);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Palette.transparent,
      child: InkWell(
        onTap: state.onRepairAll,
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
              Icons.build,
              color: Palette.white,
            ),
          ),
        ),
      ),
    );
  }
}

class ResourceIndicator extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String value;

  const ResourceIndicator({
    required this.icon,
    required this.color,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 25,
          color: color,
        ),
        const HBox(10),
        Container(
          height: 30,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Palette.hudResourceIndicator,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: Label(
              text: value,
              size: 15,
            ),
          ),
        ),
      ],
    );
  }
}
