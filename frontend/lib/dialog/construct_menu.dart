import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:tensionnode/game/game_component.dart';
import 'package:tensionnode/types/node_type.dart';
import 'package:tensionnode/types/resource_type.dart';
import 'package:tensionnode/utils/palette.dart';
import 'package:tensionnode/widgets/label.dart';
import 'package:tensionnode/widgets/menu_button.dart';

class ConstructMenu extends StatefulWidget {
  final GameComponent game;

  static const String NAME = 'construct_menu';

  const ConstructMenu(this.game);

  factory ConstructMenu.builder(BuildContext _, GameComponent game) =>
      ConstructMenu(game);

  @override
  State<ConstructMenu> createState() => _ConstructMenuState();
}

class _ConstructMenuState extends State<ConstructMenu> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 850,
        height: 390,
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
                TabButtons(
                  selectedIndex,
                  onTabSelected,
                ),
                const HBox(20),
                BuildingList(
                  _types(selectedIndex),
                  onBuild,
                ),
              ],
            ),
            const VBox(10),
            MenuButton(
              text: 'Close',
              color: Palette.lightGrey,
              onPressed: _closeMenu,
            ),
          ],
        ),
      ),
    );
  }

  void onTabSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void onBuild(NodeType type) {
    _closeMenu();
    widget.game.enableBuildingMode(type);
  }

  List<NodeType> _types(int index) {
    if (index == 0) {
      return NodeType.powerPlants();
    } else if (index == 1) {
      return NodeType.extractors();
    } else if (index == 2) {
      return NodeType.processors();
    } else if (index == 3) {
      return NodeType.factories();
    } else {
      throw Exception('Invalid build tab index');
    }
  }

  void _closeMenu() => widget.game.closeMenu(name: ConstructMenu.NAME);
}

class TabButtons extends StatelessWidget {
  final int indexSelected;
  final Function(int) onSelected;

  const TabButtons(this.indexSelected, this.onSelected);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TabButton(
          index: 0,
          name: 'Power plants',
          color: Palette.buildTypeEnergy,
          selected: indexSelected == 0,
          onSelected: onSelected,
        ),
        TabButton(
          index: 1,
          name: 'Extractors',
          color: Palette.buildTypeExtractors,
          selected: indexSelected == 1,
          onSelected: onSelected,
        ),
        TabButton(
          index: 2,
          name: 'Processors',
          color: Palette.buildTypeProcessors,
          selected: indexSelected == 2,
          onSelected: onSelected,
        ),
        TabButton(
          index: 3,
          name: 'Factories',
          color: Palette.buildTypeFactories,
          selected: indexSelected == 3,
          onSelected: onSelected,
        ),
      ],
    );
  }
}

class TabButton extends StatelessWidget {
  final int index;
  final String name;
  final Color color;
  final bool selected;
  final Function(int) onSelected;

  const TabButton({
    required this.index,
    required this.name,
    required this.color,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Palette.transparent,
      child: InkWell(
        onTap: () => onSelected(index),
        child: Container(
          width: 200,
          color: selected ? Palette.white.withAlpha(128) : Palette.transparent,
          padding: const EdgeInsets.all(10),
          child: Label(
            text: name.toUpperCase(),
            align: TextAlign.center,
            color: color,
          ),
        ),
      ),
    );
  }
}

class BuildingList extends StatelessWidget {
  final List<NodeType> types;
  final Function(NodeType) onBuild;

  const BuildingList(this.types, this.onBuild);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 590,
      height: 290,
      child: GridView.count(
        crossAxisCount: 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: [
          for (final NodeType type in types) BuildingCard(type, onBuild),
        ],
      ),
    );
  }
}

class BuildingCard extends StatelessWidget {
  final NodeType type;
  final Function(NodeType) onBuild;

  const BuildingCard(this.type, this.onBuild);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Palette.transparent,
      child: InkWell(
        onTap: () => onBuild(type),
        child: Container(
          color: Palette.white.withAlpha(128),
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Label(
                text: type.toString().toUpperCase(),
                size: 10,
                align: TextAlign.center,
              ),
              const VBox(10),
              SizedBox(
                width: 55,
                height: 55,
                child: Image.asset(
                  'images/${type.sprite}',
                ),
              ),
              const VBox(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (final MapEntry<ResourceType, int> entry
                      in type.cost.entries)
                    BuildingCost(entry.key, entry.value),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BuildingCost extends StatelessWidget {
  final ResourceType type;
  final int amount;

  const BuildingCost(this.type, this.amount);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: Image.asset(
            'images/${type.sprite}',
          ),
        ),
        const HBox(5),
        Label(
          text: '$amount',
          size: 10,
        ),
      ],
    );
  }
}
