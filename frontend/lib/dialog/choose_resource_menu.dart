import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:tensionplanet/game/game_component.dart';
import 'package:tensionplanet/types/resource_type.dart';
import 'package:tensionplanet/utils/palette.dart';
import 'package:tensionplanet/widgets/label.dart';
import 'package:tensionplanet/widgets/menu_button.dart';

class ChooseResourceMenu extends StatelessWidget {
  final GameComponent game;

  static const String NAME = 'chose_resource_menu';

  const ChooseResourceMenu(this.game);

  factory ChooseResourceMenu.builder(BuildContext _, GameComponent game) =>
      ChooseResourceMenu(game);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 740,
        height: 450,
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

  void onSelected(ResourceType type) {
    _closeMenu();
  }

  void _closeMenu() => game.closeMenu(name: ChooseResourceMenu.NAME);
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
          for (final ResourceType type in ResourceType.values)
            if (type != ResourceType.drone) ResourceCard(type, onSelected),
        ],
      ),
    );
  }
}

class ResourceCard extends StatelessWidget {
  final ResourceType type;
  final Function(ResourceType) onSelected;

  const ResourceCard(this.type, this.onSelected);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Palette.transparent,
      child: InkWell(
        onTap: () => onSelected(type),
        child: Container(
          color: Palette.white.withAlpha(128),
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Label(
                text: type.toString(),
                size: 8,
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
            ],
          ),
        ),
      ),
    );
  }
}
