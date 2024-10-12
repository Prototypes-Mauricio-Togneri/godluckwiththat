import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/colony.dart';
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
          ResourcesSummary(state.colony),
          const Spacer(),
          LimitsIndicator(state.colony),
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
  final Colony colony;

  const ResourcesSummary(this.colony);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ResourceSummary(
          size: 90,
          sprite: ResourceType.food.sprite,
          value: Formatter.resource(colony.resources.get(ResourceType.food)),
          tooltip: ComplexTooltip.storedResource(
            colony: colony,
            resourceType: ResourceType.food,
          ),
          color: _consumableResourceColor(
            colony: colony,
            resourceType: ResourceType.food,
          ),
        ),
        const HBox(10),
        ResourceSummary(
          size: 90,
          sprite: ResourceType.wood.sprite,
          value: Formatter.resource(colony.resources.get(ResourceType.wood)),
          tooltip: ComplexTooltip.storedResource(
            colony: colony,
            resourceType: ResourceType.wood,
          ),
          color: _consumableResourceColor(
            colony: colony,
            resourceType: ResourceType.wood,
          ),
        ),
        const HBox(10),
        ResourceSummary(
          size: 90,
          sprite: ResourceType.stone.sprite,
          value: Formatter.resource(colony.resources.get(ResourceType.stone)),
          tooltip: ComplexTooltip.storedResource(
            colony: colony,
            resourceType: ResourceType.stone,
          ),
          color: _storedResourceColor(
            colony: colony,
            resourceType: ResourceType.stone,
          ),
        ),
        const HBox(10),
        ResourceSummary(
          size: 90,
          sprite: ResourceType.copper.sprite,
          value: Formatter.resource(colony.resources.get(ResourceType.copper)),
          tooltip: ComplexTooltip.storedResource(
            colony: colony,
            resourceType: ResourceType.copper,
          ),
          color: _storedResourceColor(
            colony: colony,
            resourceType: ResourceType.copper,
          ),
        ),
        const HBox(10),
        ResourceSummary(
          size: 90,
          sprite: ResourceType.iron.sprite,
          value: Formatter.resource(colony.resources.get(ResourceType.iron)),
          tooltip: ComplexTooltip.storedResource(
            colony: colony,
            resourceType: ResourceType.iron,
          ),
          color: _storedResourceColor(
            colony: colony,
            resourceType: ResourceType.iron,
          ),
        ),
        const HBox(10),
        ResourceSummary(
          size: 90,
          sprite: ResourceType.gold.sprite,
          value: Formatter.resource(colony.resources.get(ResourceType.gold)),
          tooltip: ComplexTooltip.storedResource(
            colony: colony,
            resourceType: ResourceType.gold,
          ),
          color: _storedResourceColor(
            colony: colony,
            resourceType: ResourceType.gold,
          ),
        ),
        const HBox(10),
        ResourceSummary(
          size: 90,
          sprite: ResourceType.faith.sprite,
          value: Formatter.resource(colony.resources.get(ResourceType.faith)),
          tooltip: ComplexTooltip.unstoredResource(
            colony: colony,
            resourceType: ResourceType.faith,
          ),
          color: _storedResourceColor(
            colony: colony,
            resourceType: ResourceType.faith,
          ),
        ),
        const HBox(10),
        ResourceSummary(
          size: 90,
          sprite: ResourceType.knowledge.sprite,
          value:
              Formatter.resource(colony.resources.get(ResourceType.knowledge)),
          tooltip: ComplexTooltip.unstoredResource(
            colony: colony,
            resourceType: ResourceType.knowledge,
          ),
          color: _storedResourceColor(
            colony: colony,
            resourceType: ResourceType.knowledge,
          ),
        ),
      ],
    );
  }

  Color _consumableResourceColor({
    required Colony colony,
    required ResourceType resourceType,
  }) {
    final num amount = colony.resources.get(resourceType);
    final num capacity = colony.warehouseCapacity;
    final bool full = amount >= capacity;
    final num production = colony.productionOf(resourceType);

    return (full || production <= 0) ? Palette.textError : Palette.textLevel1;
  }

  Color _storedResourceColor({
    required Colony colony,
    required ResourceType resourceType,
  }) {
    final num amount = colony.resources.get(resourceType);
    final num capacity = colony.warehouseCapacity;
    final bool full = amount >= capacity;

    return full ? Palette.textError : Palette.textLevel1;
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
  final Colony colony;

  const LimitsIndicator(this.colony);

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
                  '${Formatter.resource(colony.totalWorkers)}/${Formatter.resource(colony.populationLimit)}',
              color: (colony.totalWorkers >= colony.populationLimit)
                  ? Palette.textError
                  : Palette.textLevel1,
              tooltip: const SimpleTooltip('Population'),
            ),
            const HBox(5),
            ResourceSummary(
              size: 70,
              sprite: Assets.IMAGES_OTHER_IDLE,
              value: '${colony.freeWorkers}',
              color: (colony.freeWorkers > 0)
                  ? Palette.textError
                  : Palette.textLevel1,
              tooltip: const SimpleTooltip('Idle workers'),
            ),
            const HBox(10),
            ResourceSummary(
              size: 100,
              sprite: Assets.IMAGES_OTHER_HOUSE,
              value:
                  '${colony.territorySlotsUsed}/${colony.territorySlotsTotal}',
              color: (colony.territorySlotsUsed >= colony.territorySlotsTotal)
                  ? Palette.textError
                  : Palette.textLevel1,
              tooltip: const SimpleTooltip('Territory'),
            ),
          ],
        ),
      ],
    );
  }
}
