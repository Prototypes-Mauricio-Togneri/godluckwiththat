import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/states/game_state.dart';
import 'package:godluckwiththat/types/resource_type.dart';
import 'package:godluckwiththat/utils/assets.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/images/image_asset.dart';
import 'package:godluckwiththat/widgets/labels/label.dart';

class TopMenu extends StatelessWidget {
  final GameState state;

  const TopMenu(this.state);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 35,
      color: Palette.backgroundTopBar.withAlpha(200),
      child: Row(
        children: [
          const HBox(5),
          SeasonIndicator(state),
          const HBox(50),
          ResourcesIndicator(state),
        ],
      ),
    );
  }
}

class TopBarContainer extends StatelessWidget {
  final double size;
  final Widget child;

  const TopBarContainer({
    required this.size,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25,
      width: size,
      color: Palette.backgroundTopBarContainer,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: child,
        ),
      ),
    );
  }
}

class SeasonIndicator extends StatelessWidget {
  final GameState state;

  const SeasonIndicator(this.state);

  @override
  Widget build(BuildContext context) {
    return const TopBarContainer(
      size: 80,
      child: Row(
        children: [
          Icon(
            Icons.wb_sunny,
            color: Colors.orange,
            size: 12,
          ),
          HBox(5),
          Label(text: 'Summer'),
        ],
      ),
    );
  }
}

class ResourcesIndicator extends StatelessWidget {
  final GameState state;

  const ResourcesIndicator(this.state);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ResourceIndicator(
          sprite: Assets.IMAGES_RESOURCES_FOOD,
          value: state.colony.resourceInventory.get(ResourceType.food),
        ),
        const HBox(10),
        ResourceIndicator(
          sprite: Assets.IMAGES_RESOURCES_WOOD,
          value: state.colony.resourceInventory.get(ResourceType.wood),
        ),
        const HBox(10),
        ResourceIndicator(
          sprite: Assets.IMAGES_RESOURCES_STONE,
          value: state.colony.resourceInventory.get(ResourceType.stone),
        ),
        const HBox(10),
        ResourceIndicator(
          sprite: Assets.IMAGES_RESOURCES_COPPER,
          value: state.colony.resourceInventory.get(ResourceType.copper),
        ),
        const HBox(10),
        ResourceIndicator(
          sprite: Assets.IMAGES_RESOURCES_IRON,
          value: state.colony.resourceInventory.get(ResourceType.iron),
        ),
        const HBox(10),
        ResourceIndicator(
          sprite: Assets.IMAGES_RESOURCES_GOLD,
          value: state.colony.resourceInventory.get(ResourceType.gold),
        ),
      ],
    );
  }
}

class ResourceIndicator extends StatelessWidget {
  final String sprite;
  final num value;

  const ResourceIndicator({
    required this.sprite,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TopBarContainer(
          size: 70,
          child: Row(
            children: [
              ImageAsset(
                path: sprite,
                size: 15,
              ),
              const Spacer(),
              Label(
                text: value.ceil().toString(),
                size: 15,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
