import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:tensionnode/components/base/building.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/game/game_component.dart';
import 'package:tensionnode/services/palette.dart';
import 'package:tensionnode/types/resource_type.dart';
import 'package:tensionnode/widgets/label.dart';
import 'package:tensionnode/widgets/menu_button.dart';

class BuildingMenu extends StatelessWidget {
  final GameComponent game;
  final Building node;

  const BuildingMenu(this.game, this.node);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20,
        bottom: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Label(
            text: node.type.name.toUpperCase(),
            align: TextAlign.center,
          ),
          const VBox(10),
          Label(
            text: '${node.location.i}, ${node.location.j}',
            align: TextAlign.center,
          ),
          if (node.resourcesRequired.isNotEmpty) InputSection(node),
          OutputSection(node),
          const VBox(10),
          MenuButton(
            text: 'Center',
            icon: Icons.filter_tilt_shift,
            color: Palette.primary,
            onPressed: () => _onCenter(node),
          ),
          MenuButton(
            text: 'Destroy',
            icon: Icons.delete,
            color: Palette.error,
            onPressed: _onDestroy,
          ),
          MenuButton(
            text: 'Close',
            icon: Icons.close,
            color: Palette.lightGrey,
            onPressed: _closeMenu,
          ),
        ],
      ),
    );
  }

  void _onCenter(Node node) => game.centerMap(node.position);

  void _onDestroy() {
    final Node node = game.selectedNode();
    node.destroy();
    _closeMenu();
  }

  void _closeMenu() => game.unselectNode();
}

class InputSection extends StatelessWidget {
  final Building node;

  const InputSection(this.node);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const VBox(20),
        Label(
          text: 'Input'.toUpperCase(),
          align: TextAlign.center,
        ),
        const VBox(10),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final MapEntry<ResourceType, int> entry
                in node.resourcesRequired.entries)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: Image.asset(
                        'images/${entry.key.sprite}',
                      ),
                    ),
                    const HBox(10),
                    Label(
                      text: '${entry.value}',
                      align: TextAlign.center,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class OutputSection extends StatelessWidget {
  final Building node;

  const OutputSection(this.node);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const VBox(20),
        Label(
          text: 'Output'.toUpperCase(),
          align: TextAlign.center,
        ),
        const VBox(10),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 30,
                    height: 30,
                    child: Image.asset(
                      'images/${node.resourceProduced.sprite}',
                    ),
                  ),
                  const HBox(10),
                  Label(
                    text: '${node.output}',
                    align: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
