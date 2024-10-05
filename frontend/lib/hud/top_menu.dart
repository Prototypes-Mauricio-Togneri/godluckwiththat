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
      height: 40,
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
    return CustomTooltip(
      content: const SimpleTooltip('Pause'),
      child: Material(
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
      height: 30,
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
        size: 100,
        child: Row(
          children: [
            Icon(
              Icons.wb_sunny,
              color: Colors.orange,
              size: 18,
            ),
            HBox(5),
            Label(
              text: 'Summer',
              size: 18,
            ),
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
          size: 90,
          sprite: ResourceType.food.sprite,
          value: state.colony.resourceInventory
              .get(ResourceType.food)
              .floor()
              .toString(),
          tooltip: ComplexTooltip.resourceConsumable(
            colony: state.colony,
            resourceType: ResourceType.food,
          ),
        ),
        const HBox(10),
        ResourceIndicator(
          size: 90,
          sprite: ResourceType.wood.sprite,
          value: state.colony.resourceInventory
              .get(ResourceType.wood)
              .floor()
              .toString(),
          tooltip: ComplexTooltip.resourceConsumable(
            colony: state.colony,
            resourceType: ResourceType.wood,
          ),
        ),
        const HBox(10),
        ResourceIndicator(
          size: 90,
          sprite: ResourceType.stone.sprite,
          value: state.colony.resourceInventory
              .get(ResourceType.stone)
              .floor()
              .toString(),
          tooltip: ComplexTooltip.resourceNonConsumable(
            colony: state.colony,
            resourceType: ResourceType.stone,
          ),
        ),
        const HBox(10),
        ResourceIndicator(
          size: 90,
          sprite: ResourceType.copper.sprite,
          value: state.colony.resourceInventory
              .get(ResourceType.copper)
              .floor()
              .toString(),
          tooltip: ComplexTooltip.resourceNonConsumable(
            colony: state.colony,
            resourceType: ResourceType.copper,
          ),
        ),
        const HBox(10),
        ResourceIndicator(
          size: 90,
          sprite: ResourceType.iron.sprite,
          value: state.colony.resourceInventory
              .get(ResourceType.iron)
              .floor()
              .toString(),
          tooltip: ComplexTooltip.resourceNonConsumable(
            colony: state.colony,
            resourceType: ResourceType.iron,
          ),
        ),
        const HBox(10),
        ResourceIndicator(
          size: 90,
          sprite: ResourceType.gold.sprite,
          value: state.colony.resourceInventory
              .get(ResourceType.gold)
              .floor()
              .toString(),
          tooltip: ComplexTooltip.resourceNonConsumable(
            colony: state.colony,
            resourceType: ResourceType.gold,
          ),
        ),
        const HBox(10),
        ResourceIndicator(
          size: 90,
          sprite: ResourceType.faith.sprite,
          value: state.colony.resourceInventory
              .get(ResourceType.faith)
              .floor()
              .toString(),
          tooltip: SimpleTooltip.resource(ResourceType.faith),
        ),
        const HBox(10),
        ResourceIndicator(
          size: 90,
          sprite: ResourceType.knowledge.sprite,
          value: state.colony.resourceInventory
              .get(ResourceType.knowledge)
              .floor()
              .toString(),
          tooltip: SimpleTooltip.resource(ResourceType.knowledge),
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
                  size: 18,
                ),
                const Spacer(),
                Label(
                  text: value,
                  size: 18,
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
              size: 100,
              sprite: Assets.IMAGES_UNITS_WORKER,
              value:
                  '${Formatter.resource(state.colony.currentPopulation)}/${Formatter.resource(state.colony.populationLimit)}',
              tooltip: const SimpleTooltip('Population'),
            ),
            const HBox(5),
            ResourceIndicator(
              size: 70,
              sprite: Assets.IMAGES_OTHER_IDLE,
              value: '${state.colony.freeWorkers}',
              color: (state.colony.freeWorkers > 0)
                  ? Palette.error
                  : Palette.black,
              tooltip: const SimpleTooltip('Idle workers'),
            ),
            const HBox(10),
            ResourceIndicator(
              size: 100,
              sprite: Assets.IMAGES_OTHER_HOUSE,
              value:
                  '${state.colony.territorySlotsUsed}/${state.colony.territorySlotsTotal}',
              tooltip: const SimpleTooltip('Territory'),
            ),
          ],
        ),
      ],
    );
  }
}
