import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:tensionplanet/game/game_component.dart';
import 'package:tensionplanet/types/node_type.dart';
import 'package:tensionplanet/utils/palette.dart';
import 'package:tensionplanet/widgets/label.dart';
import 'package:tensionplanet/widgets/menu_button.dart';

class ConstructOverlay extends StatefulWidget {
  final GameComponent game;

  static const String NAME = 'construct_overlay';

  const ConstructOverlay(this.game);

  factory ConstructOverlay.builder(BuildContext _, GameComponent game) =>
      ConstructOverlay(game);

  @override
  State<ConstructOverlay> createState() => _ConstructOverlayState();
}

class _ConstructOverlayState extends State<ConstructOverlay> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 850,
        height: 395,
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
                  onInfo,
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

  void onBuild(NodeType nodeType) {
    _closeMenu();

    if (nodeType == NodeType.warehouse) {
      widget.game.openChoseResourceMenu();
    } else {
      widget.game.enableBuildingMode(nodeType: nodeType);
    }
  }

  void onInfo(NodeType nodeType) {}

  List<NodeType> _types(int index) {
    if (index == 0) {
      return NodeType.powerPlants();
    } else if (index == 1) {
      return NodeType.extractors();
    } else if (index == 2) {
      return NodeType.processors();
    } else if (index == 3) {
      return NodeType.assemblers();
    } else if (index == 4) {
      return NodeType.factories();
    } else if (index == 5) {
      return NodeType.other();
    } else {
      throw Exception('Invalid build tab index');
    }
  }

  void _closeMenu() => widget.game.closeMenu(name: ConstructOverlay.NAME);
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
          name: 'Assemblers',
          color: Palette.buildTypeAssemblers,
          selected: indexSelected == 3,
          onSelected: onSelected,
        ),
        TabButton(
          index: 4,
          name: 'Factories',
          color: Palette.buildTypeFactories,
          selected: indexSelected == 4,
          onSelected: onSelected,
        ),
        TabButton(
          index: 5,
          name: 'Other',
          color: Palette.buildTypeOther,
          selected: indexSelected == 5,
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
            text: name,
            align: TextAlign.center,
            color: color,
          ),
        ),
      ),
    );
  }
}

class BuildingList extends StatelessWidget {
  final List<NodeType> nodeTypes;
  final Function(NodeType) onBuild;
  final Function(NodeType) onInfo;

  const BuildingList(this.nodeTypes, this.onBuild, this.onInfo);

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
          for (final NodeType resourceType in nodeTypes)
            BuildingCard(resourceType, onBuild, onInfo),
        ],
      ),
    );
  }
}

class BuildingCard extends StatelessWidget {
  final NodeType nodeType;
  final Function(NodeType) onBuild;
  final Function(NodeType) onInfo;

  const BuildingCard(this.nodeType, this.onBuild, this.onInfo);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Palette.transparent,
      child: InkWell(
        onTap: () => onBuild(nodeType),
        child: Container(
          color: Palette.white.withAlpha(128),
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Label(
                text: nodeType.toString(),
                size: 8,
                align: TextAlign.center,
              ),
              const VBox(10),
              SizedBox(
                width: 55,
                height: 55,
                child: Image.asset(
                  'images/${nodeType.sprite}',
                ),
              ),
              const VBox(5),
              MenuButton(
                text: 'Info',
                icon: Icons.info_outline,
                color: Palette.primary,
                onPressed: () => onInfo(nodeType),
                size: 9,
                expand: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
