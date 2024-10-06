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
          ResourcesSummary(state),
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
              color: Palette.iconLevel1,
            ),
          ),
        ),
      ),
    );
  }
}

class TopBarContainer extends StatelessWidget {
  final Widget child;
  final double? size;

  const TopBarContainer({
    required this.child,
    this.size,
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
        child: Row(
          children: [
            Icon(
              Icons.wb_sunny,
              color: Colors.orange,
              size: 16,
            ),
            HBox(5),
            Label(
              text: 'Summer',
              size: 14,
            ),
            HBox(5),
          ],
        ),
      ),
    );
  }
}

class ResourcesSummary extends StatelessWidget {
  final GameState state;

  const ResourcesSummary(this.state);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ResourceSummary(
          size: 90,
          sprite: ResourceType.food.sprite,
          value:
              state.colony.resources.get(ResourceType.food).floor().toString(),
          tooltip: ComplexTooltip.resourceConsumable(
            colony: state.colony,
            resourceType: ResourceType.food,
          ),
          color: Palette.textLevel1,
        ),
        const HBox(10),
        ResourceSummary(
          size: 90,
          sprite: ResourceType.wood.sprite,
          value:
              state.colony.resources.get(ResourceType.wood).floor().toString(),
          tooltip: ComplexTooltip.resourceConsumable(
            colony: state.colony,
            resourceType: ResourceType.wood,
          ),
          color: Palette.textLevel1,
        ),
        const HBox(10),
        ResourceSummary(
          size: 90,
          sprite: ResourceType.stone.sprite,
          value:
              state.colony.resources.get(ResourceType.stone).floor().toString(),
          tooltip: ComplexTooltip.resourceNonConsumable(
            colony: state.colony,
            resourceType: ResourceType.stone,
          ),
          color: Palette.textLevel1,
        ),
        const HBox(10),
        ResourceSummary(
          size: 90,
          sprite: ResourceType.copper.sprite,
          value: state.colony.resources
              .get(ResourceType.copper)
              .floor()
              .toString(),
          tooltip: ComplexTooltip.resourceNonConsumable(
            colony: state.colony,
            resourceType: ResourceType.copper,
          ),
          color: Palette.textLevel1,
        ),
        const HBox(10),
        ResourceSummary(
          size: 90,
          sprite: ResourceType.iron.sprite,
          value:
              state.colony.resources.get(ResourceType.iron).floor().toString(),
          tooltip: ComplexTooltip.resourceNonConsumable(
            colony: state.colony,
            resourceType: ResourceType.iron,
          ),
          color: Palette.textLevel1,
        ),
        const HBox(10),
        ResourceSummary(
          size: 90,
          sprite: ResourceType.gold.sprite,
          value:
              state.colony.resources.get(ResourceType.gold).floor().toString(),
          tooltip: ComplexTooltip.resourceNonConsumable(
            colony: state.colony,
            resourceType: ResourceType.gold,
          ),
          color: Palette.textLevel1,
        ),
        const HBox(10),
        ResourceSummary(
          size: 90,
          sprite: ResourceType.faith.sprite,
          value:
              state.colony.resources.get(ResourceType.faith).floor().toString(),
          tooltip: SimpleTooltip.resource(ResourceType.faith),
          color: Palette.textLevel1,
        ),
        const HBox(10),
        ResourceSummary(
          size: 90,
          sprite: ResourceType.knowledge.sprite,
          value: state.colony.resources
              .get(ResourceType.knowledge)
              .floor()
              .toString(),
          tooltip: SimpleTooltip.resource(ResourceType.knowledge),
          color: Palette.textLevel1,
        ),
      ],
    );
  }
}

class ResourceSummary extends StatelessWidget {
  final double size;
  final String sprite;
  final String value;
  final Widget tooltip;
  final Color color;

  const ResourceSummary({
    required this.size,
    required this.sprite,
    required this.value,
    required this.tooltip,
    required this.color,
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
                  size: 16,
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
            ResourceSummary(
              size: 100,
              sprite: Assets.IMAGES_UNITS_WORKER,
              value:
                  '${Formatter.resource(state.colony.currentPopulation)}/${Formatter.resource(state.colony.populationLimit)}',
              color: Palette.textLevel1,
              tooltip: const SimpleTooltip('Population'),
            ),
            const HBox(5),
            ResourceSummary(
              size: 70,
              sprite: Assets.IMAGES_OTHER_IDLE,
              value: '${state.colony.freeWorkers}',
              color: (state.colony.freeWorkers > 0)
                  ? Palette.error
                  : Palette.textLevel1,
              tooltip: const SimpleTooltip('Idle workers'),
            ),
            const HBox(10),
            ResourceSummary(
              size: 100,
              sprite: Assets.IMAGES_OTHER_HOUSE,
              value:
                  '${state.colony.territorySlotsUsed}/${state.colony.territorySlotsTotal}',
              color: Palette.textLevel1,
              tooltip: const SimpleTooltip('Territory'),
            ),
          ],
        ),
      ],
    );
  }
}
