import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:tensionnode/services/palette.dart';
import 'package:tensionnode/states/game_state.dart';
import 'package:tensionnode/types/resource_type.dart';
import 'package:tensionnode/widgets/label.dart';
import 'package:tensionnode/widgets/menu_button.dart';

class VerticalHud extends StatelessWidget {
  final GameState state;

  const VerticalHud(this.state);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      color: Palette.hudBackground,
      child: IntrinsicWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            MenuButton(
              text: 'Menu',
              icon: Icons.menu,
              color: Palette.blue,
              onPressed: state.onMainMenu,
              topPadding: 0,
            ),
            const Spacer(),
            MenuButton(
              text: 'Repair all',
              icon: Icons.build,
              color: Palette.green,
              onPressed: state.onRepairAll,
            ),
            MenuButton(
              text: 'Report bug',
              icon: Icons.bug_report,
              color: Palette.red,
              onPressed: state.onReportBug,
            ),
          ],
        ),
      ),
    );
  }
}

class HorizontalHud extends StatelessWidget {
  final GameState state;

  const HorizontalHud(this.state);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.all(5),
      color: Palette.hudBackground,
      child: Row(
        children: [
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
        ],
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
