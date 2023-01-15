import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:tensionnode/model/nodes/heavy_turret.dart';
import 'package:tensionnode/model/nodes/light_turret.dart';
import 'package:tensionnode/model/nodes/power_plant.dart';
import 'package:tensionnode/model/nodes/wall.dart';
import 'package:tensionnode/services/palette.dart';
import 'package:tensionnode/states/game_state.dart';
import 'package:tensionnode/states/hud_state.dart';
import 'package:tensionnode/types/node_type.dart';
import 'package:tensionnode/types/resource_type.dart';
import 'package:tensionnode/widgets/label.dart';
import 'package:tensionnode/widgets/menu_button.dart';

class VerticalHud extends StatelessWidget {
  final GameState state;

  const VerticalHud(this.state);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(10),
      color: Palette.hudBackground,
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
          const VBox(20),
          const Label(text: 'Resources'),
          MenuButton(
            text: 'Mine',
            icon: Icons.factory,
            color: Colors.blueGrey,
            onPressed: () => state.onBuild(NodeType.mine),
            tooltip: '',
          ),
          const VBox(40),
          const Label(text: 'Energy'),
          MenuButton(
            text: 'Power plant',
            icon: Icons.bolt,
            color: Colors.blueGrey,
            onPressed: () => state.onBuild(NodeType.power_plant),
            tooltip: PowerPlant.cost(),
          ),
          const VBox(40),
          const Label(text: 'Defenses'),
          MenuButton(
            text: 'Wall',
            icon: Icons.cell_tower,
            color: Colors.blueGrey,
            onPressed: () => state.onBuild(NodeType.wall),
            tooltip: Wall.cost(),
          ),
          MenuButton(
            text: 'Light turret',
            icon: Icons.cell_tower,
            color: Colors.blueGrey,
            onPressed: () => state.onBuild(NodeType.light_turret),
            tooltip: LightTurret.cost(),
          ),
          MenuButton(
            text: 'Heavy turret',
            icon: Icons.cell_tower,
            color: Colors.blueGrey,
            onPressed: () => state.onBuild(NodeType.heavy_turret),
            tooltip: HeavyTurret.cost(),
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
            onPressed: () => state.onReportBug(context),
          ),
        ],
      ),
    );
  }
}

class HorizontalHud extends StatelessWidget {
  final HudState state;

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
            color: ResourceType.red.color,
            value: state.resource1,
          ),
          const HBox(30),
          ResourceIndicator(
            icon: Icons.square,
            color: ResourceType.green.color,
            value: state.resource2,
          ),
          const HBox(30),
          ResourceIndicator(
            icon: Icons.square,
            color: ResourceType.blue.color,
            value: state.resource3,
          ),
          const HBox(30),
          ResourceIndicator(
            icon: Icons.bolt,
            color: Palette.energy,
            value: '${state.energyConsumed} / ${state.energyProduced}',
          ),
          const HBox(30),
          const ResourceIndicator(
            icon: Icons.speed,
            color: Palette.energy,
            value: '',
            width: 50,
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
  final double? width;

  const ResourceIndicator({
    required this.icon,
    required this.color,
    required this.value,
    this.width,
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
          width: width,
          height: 30,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Palette.hudResourceIndicator,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Label(
                text: value,
                size: 15,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
