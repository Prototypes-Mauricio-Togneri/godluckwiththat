import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/states/game_state.dart';
import 'package:godluckwiththat/types/resource_type.dart';
import 'package:godluckwiththat/utils/assets.dart';
import 'package:godluckwiththat/utils/formatter.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/images/image_asset.dart';
import 'package:godluckwiththat/widgets/labels/label.dart';
import 'package:godluckwiththat/widgets/misc/custom_tooltip.dart';

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
          const Spacer(),
          ResourcesIndicator(state),
          const Spacer(),
          LimitsIndicator(state),
          const Spacer(),
          PauseButton(state.onPause),
        ],
      ),
    );
  }
}

class PauseButton extends StatelessWidget {
  final VoidCallback onPressed;

  const PauseButton(this.onPressed);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Palette.transparent,
      child: InkWell(
        hoverColor: Palette.backgroundTransparent3.withAlpha(100),
        onTap: onPressed,
        child: const Padding(
          padding: EdgeInsets.all(10),
          child: Icon(
            Icons.pause,
            size: 15,
            color: Palette.white,
          ),
        ),
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
    return const CustomTooltip(
      content: SimpleTooltip('Season'),
      child: TopBarContainer(
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
          size: 70,
          sprite: ResourceType.food.sprite,
          value: state.colony.resourceInventory
              .get(ResourceType.food)
              .floor()
              .toString(),
          tooltip: ComplexTooltip(
            title: 'Food',
            content:
                '${Formatter.production(state.colony.productionOf(ResourceType.food))}/s',
          ),
        ),
        const HBox(10),
        ResourceIndicator(
          size: 70,
          sprite: ResourceType.wood.sprite,
          value: state.colony.resourceInventory
              .get(ResourceType.wood)
              .floor()
              .toString(),
          tooltip: ComplexTooltip(
            title: 'Wood',
            content:
                '${Formatter.production(state.colony.productionOf(ResourceType.wood))}/s',
          ),
        ),
        const HBox(10),
        ResourceIndicator(
          size: 70,
          sprite: ResourceType.stone.sprite,
          value: state.colony.resourceInventory
              .get(ResourceType.stone)
              .floor()
              .toString(),
          tooltip: SimpleTooltip(ResourceType.stone.localized),
        ),
        const HBox(10),
        ResourceIndicator(
          size: 70,
          sprite: ResourceType.copper.sprite,
          value: state.colony.resourceInventory
              .get(ResourceType.copper)
              .floor()
              .toString(),
          tooltip: SimpleTooltip(ResourceType.copper.localized),
        ),
        const HBox(10),
        ResourceIndicator(
          size: 70,
          sprite: ResourceType.iron.sprite,
          value: state.colony.resourceInventory
              .get(ResourceType.iron)
              .floor()
              .toString(),
          tooltip: SimpleTooltip(ResourceType.iron.localized),
        ),
        const HBox(10),
        ResourceIndicator(
          size: 70,
          sprite: ResourceType.gold.sprite,
          value: state.colony.resourceInventory
              .get(ResourceType.gold)
              .floor()
              .toString(),
          tooltip: SimpleTooltip(ResourceType.gold.localized),
        ),
        const HBox(10),
        ResourceIndicator(
          size: 70,
          sprite: ResourceType.faith.sprite,
          value: state.colony.resourceInventory
              .get(ResourceType.faith)
              .floor()
              .toString(),
          tooltip: SimpleTooltip(ResourceType.faith.localized),
        ),
        const HBox(10),
        ResourceIndicator(
          size: 70,
          sprite: ResourceType.knowledge.sprite,
          value: state.colony.resourceInventory
              .get(ResourceType.knowledge)
              .floor()
              .toString(),
          tooltip: SimpleTooltip(ResourceType.knowledge.localized),
        ),
      ],
    );
  }
}

class ResourceIndicator extends StatelessWidget {
  final double size;
  final String sprite;
  final String value;
  final Widget tooltip;
  final Color color;

  const ResourceIndicator({
    required this.size,
    required this.sprite,
    required this.value,
    required this.tooltip,
    this.color = Palette.white,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTooltip(
      content: tooltip,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TopBarContainer(
            size: size,
            child: Row(
              children: [
                ImageAsset(
                  path: sprite,
                  size: 15,
                ),
                const Spacer(),
                Label(
                  text: value,
                  size: 15,
                  color: color,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LimitsIndicator extends StatelessWidget {
  final GameState state;

  const LimitsIndicator(this.state);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ResourceIndicator(
              size: 80,
              sprite: Assets.IMAGES_UNITS_VILLAGER,
              value:
                  '${state.colony.currentPopulation}/${state.colony.populationLimit}',
              tooltip: const SimpleTooltip('Population'),
            ),
            const HBox(5),
            ResourceIndicator(
              size: 50,
              sprite: Assets.IMAGES_OTHER_IDLE,
              value: '${state.colony.freeVillagers}',
              color: Palette.error,
              tooltip: const SimpleTooltip('Idle workers'),
            ),
            const HBox(10),
            ResourceIndicator(
              size: 80,
              sprite: Assets.IMAGES_OTHER_HOUSE,
              value:
                  '${state.colony.territorySlotsUsed}/${state.colony.territorySlotsTotal}',
              tooltip: const SimpleTooltip('Territory size'),
            ),
          ],
        ),
      ],
    );
  }
}
