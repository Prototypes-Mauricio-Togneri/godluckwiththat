import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/extensions/resource_map_extension.dart';
import 'package:godluckwiththat/models/buildings/building.dart';
import 'package:godluckwiththat/models/inventory.dart';
import 'package:godluckwiththat/models/tasks/upgrade_building_task.dart';
import 'package:godluckwiththat/states/game_state.dart';
import 'package:godluckwiththat/utils/assets.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/primary_button.dart';
import 'package:godluckwiththat/widgets/queue_indicator.dart';
import 'package:godluckwiththat/widgets/tooltip.dart';

class UpgradeButton extends StatelessWidget {
  final GameState state;
  final Building building;

  const UpgradeButton(this.state, this.building);

  @override
  Widget build(BuildContext context) {
    final Inventory inventory = state.colony.inventory;
    final ResourceMap cost = building.upgradeCost;
    final UpgradeBuildingTask? task = building.upgradeTask;
    final bool canUpgrade = (task == null) && inventory.hasResources(cost);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CostTooltip(
          cost: cost,
          inventory: inventory,
          showInstant: !canUpgrade,
          missingFreeVillagers: false,
          child: PrimaryButton(
            text: 'Upgrade',
            color: Palette.success,
            icon: Icons.arrow_upward,
            onPressed: canUpgrade
                ? () => state.onAddUpgradeBuildingTask(UpgradeBuildingTask(
                      building: building,
                      cost: cost,
                    ))
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
              onTap: () => state.onRemoveUpgradeBuildingTask(task),
            ),
          )
        else
          const HBox(65),
      ],
    );
  }
}
