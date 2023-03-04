import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:tensionnode/game/game_component.dart';
import 'package:tensionnode/services/palette.dart';
import 'package:tensionnode/types/node_type.dart';
import 'package:tensionnode/widgets/label.dart';
import 'package:tensionnode/widgets/menu_button.dart';

class ConstructMenu extends StatelessWidget {
  final GameComponent game;

  static const String NAME = 'construct_menu';

  const ConstructMenu(this.game);

  factory ConstructMenu.builder(BuildContext _, GameComponent game) =>
      ConstructMenu(game);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 700,
        height: 320,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Palette.grey,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BuildingGroup(
                  title: 'Energy'.toUpperCase(),
                  types: const [
                    NodeType.solar_panel,
                  ],
                  onBuild: _onBuild,
                ),
                const HBox(20),
                BuildingGroup(
                  title: 'Mines'.toUpperCase(),
                  types: const [
                    NodeType.iron_mine,
                    NodeType.copper_mine,
                    NodeType.coal_mine,
                    NodeType.stone_mine,
                  ],
                  onBuild: _onBuild,
                ),
                const HBox(20),
                BuildingGroup(
                  title: 'Smelters'.toUpperCase(),
                  types: const [
                    NodeType.iron_smelter,
                    NodeType.copper_smelter,
                  ],
                  onBuild: _onBuild,
                ),
              ],
            ),
            const VBox(10),
            Expanded(
              child: MenuButton(
                text: 'Close',
                color: Palette.lightGrey,
                onPressed: _closeMenu,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onBuild(NodeType type) {
    _closeMenu();
    game.enableBuildingMode(type);
  }

  void _closeMenu() => game.closeMenu(name: ConstructMenu.NAME);
}

class BuildingGroup extends StatelessWidget {
  final String title;
  final List<NodeType> types;
  final Function(NodeType) onBuild;

  const BuildingGroup({
    required this.title,
    required this.types,
    required this.onBuild,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Label(
            text: title,
            align: TextAlign.center,
          ),
          for (final NodeType type in types)
            MenuButton(
              text: type.toString(),
              color: Palette.primary,
              onPressed: () => onBuild(type),
            ),
        ],
      ),
    );
  }
}
