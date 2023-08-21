import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/extensions/resource_map_extension.dart';
import 'package:godluckwiththat/models/buildings/producers/well.dart';
import 'package:godluckwiththat/models/inventory.dart';
import 'package:godluckwiththat/models/tasks/upgrade_building_task.dart';
import 'package:godluckwiththat/states/game_state.dart';
import 'package:godluckwiththat/types/building_type.dart';
import 'package:godluckwiththat/utils/assets.dart';
import 'package:godluckwiththat/utils/formatter.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/image_asset.dart';
import 'package:godluckwiththat/widgets/label.dart';
import 'package:godluckwiththat/widgets/primary_button.dart';
import 'package:godluckwiththat/widgets/queue_indicator.dart';
import 'package:godluckwiththat/widgets/tooltip.dart';
import 'package:godluckwiththat/widgets/worker_selector.dart';

class WaterView extends StatelessWidget {
  final GameState state;

  const WaterView(this.state);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const VBox(30),
        WellSection(state),
      ],
    );
  }
}

class WellSection extends StatelessWidget {
  final GameState state;

  const WellSection(this.state);

  @override
  Widget build(BuildContext context) {
    final List<Well> wells = state.colony.getBuildings(Well);

    if (wells.isEmpty) {
      return const Label(
        text: 'No wells',
        color: Palette.white,
        size: 35,
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ImageAsset(
                path: BuildingType.well.sprite,
                size: 40,
              ),
              const HBox(10),
              const Label(
                text: 'Wells',
                color: Palette.white,
                size: 35,
              ),
            ],
          ),
          const VBox(20),
          for (final Well well in wells) WellEntry(state, well),
        ],
      );
    }
  }
}

class WellEntry extends StatelessWidget {
  final GameState state;
  final Well well;

  const WellEntry(this.state, this.well);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 20,
        left: 20,
        right: 20,
      ),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: Palette.lightGrey,
        ),
      ),
      child: Row(
        children: [
          Label(
            text: 'Level: ${well.level}',
            color: Palette.white,
            size: 30,
          ),
          const HBox(30),
          const Label(
            text: 'Workers:',
            color: Palette.white,
            size: 30,
          ),
          const HBox(20),
          WorkersSelector(well),
          const HBox(30),
          Label(
            text: 'Production: ${well.production}/day',
            color: (well.production > 0) ? Palette.success : Palette.error,
            size: 30,
          ),
          const HBox(30),
          Label(
            text: well.hasResourcesLeft
                ? 'Resources left: ${Formatter.resource(well.resourcesLeft)}'
                : 'Depleted',
            color: well.hasResourcesLeft ? Palette.white : Palette.error,
            size: 30,
          ),
          const HBox(30),
          UpgradeSection(state, well),
          const Spacer(),
          PrimaryButton(
            text: 'Destroy',
            expand: false,
            icon: Icons.delete,
            color: Palette.error,
            onPressed: well.destroy,
          ),
        ],
      ),
    );
  }
}

class UpgradeSection extends StatelessWidget {
  final GameState state;
  final Well well;

  const UpgradeSection(this.state, this.well);

  @override
  Widget build(BuildContext context) {
    final Inventory inventory = state.colony.inventory;
    final ResourceMap cost = well.upgradeCost;
    final bool hasResources = inventory.hasResources(cost);
    final UpgradeBuildingTask? task = well.upgradeTask;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CostTooltip(
          cost: cost,
          inventory: inventory,
          showInstant: !hasResources,
          child: PrimaryButton(
            text: 'Upgrade',
            color: Palette.success,
            icon: Icons.person,
            onPressed: (task == null) && hasResources
                ? () => state.onAddUpgradeBuilding(well, cost)
                : null,
            expand: false,
          ),
        ),
        if (task != null)
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: QueueIndicator(
              sprite: Assets.IMAGES_OTHER_UPGRADE,
              progress: task.progress,
              size: 0,
              onTap: () => state.onRemoveUpgradeBuilding(well, cost),
            ),
          )
        else
          const HBox(65),
      ],
    );
  }
}
