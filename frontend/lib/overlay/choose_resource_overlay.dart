import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:tensionplanet/game/game_component.dart';
import 'package:tensionplanet/types/node_type.dart';
import 'package:tensionplanet/types/resource_type.dart';
import 'package:tensionplanet/utils/palette.dart';
import 'package:tensionplanet/widgets/image_asset.dart';
import 'package:tensionplanet/widgets/label.dart';
import 'package:tensionplanet/widgets/menu_button.dart';

class ChooseResourceOverlay extends StatelessWidget {
  final GameComponent game;

  static const String NAME = 'chose_resource_overlay';

  const ChooseResourceOverlay(this.game);

  factory ChooseResourceOverlay.builder(BuildContext _, GameComponent game) =>
      ChooseResourceOverlay(game);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 740,
        height: 455,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Palette.grey,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ResourcesList(onSelected),
            const VBox(10),
            MenuButton(
              text: 'Cancel',
              color: Palette.lightGrey,
              onPressed: _closeMenu,
            ),
          ],
        ),
      ),
    );
  }

  void onSelected(ResourceType resourceType) {
    _closeMenu();
    game.enableBuildingMode(
      nodeType: NodeType.warehouse,
      resourceType: resourceType,
    );
  }

  void _closeMenu() => game.closeMenu(name: ChooseResourceOverlay.NAME);
}

class ResourcesList extends StatelessWidget {
  final Function(ResourceType) onSelected;

  const ResourcesList(this.onSelected);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 700,
      height: 350,
      child: GridView.count(
        crossAxisCount: 6,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: [
          for (final ResourceType resourceType in ResourceType.values)
            if ((resourceType != ResourceType.drone) &&
                (resourceType != ResourceType.time))
              ResourceCard(resourceType, onSelected),
        ],
      ),
    );
  }
}

class ResourceCard extends StatelessWidget {
  final ResourceType resourceType;
  final Function(ResourceType) onSelected;

  const ResourceCard(this.resourceType, this.onSelected);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Palette.transparent,
      child: InkWell(
        onTap: () => onSelected(resourceType),
        child: Container(
          color: Palette.white.withAlpha(128),
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Label(
                text: resourceType.toString(),
                size: 8,
                align: TextAlign.center,
              ),
              const VBox(20),
              ImageAsset(
                path: resourceType.sprite,
                size: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
