import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/extensions/resource_map_extension.dart';
import 'package:godluckwiththat/models/buildings/misc/headquarters.dart';
import 'package:godluckwiththat/models/inventory.dart';
import 'package:godluckwiththat/models/tasks/create_villager_task.dart';
import 'package:godluckwiththat/states/game_state.dart';
import 'package:godluckwiththat/types/building_type.dart';
import 'package:godluckwiththat/types/resource_type.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/label.dart';
import 'package:godluckwiththat/widgets/primary_button.dart';
import 'package:godluckwiththat/widgets/queue_indicator.dart';
import 'package:godluckwiththat/widgets/tooltip.dart';

class HeadquartersView extends StatelessWidget {
  final GameState state;

  const HeadquartersView(this.state);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const VBox(30),
        UpgradeSection(state),
        const VBox(30),
        CreateVillagerSection(state),
        const VBox(30),
        const HousingSection(),
        const VBox(30),
        BuildHouseSection(state),
      ],
    );
  }
}

class UpgradeSection extends StatelessWidget {
  final GameState state;

  const UpgradeSection(this.state);

  @override
  Widget build(BuildContext context) {
    final Headquarters headquarters = state.colony.headquarters;
    final Inventory inventory = state.colony.inventory;
    final ResourceMap upgradeCost = headquarters.upgradeCost;
    final bool hasResources = inventory.hasResources(upgradeCost);
    //final UpgradeBuildingTask? task = headquarters.upgradeTask;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Label(
          text: 'Town Center level: 3',
          color: Palette.white,
          size: 35,
        ),
        const HBox(20),
        CostTooltip(
          cost: upgradeCost,
          inventory: inventory,
          showInstant: !hasResources,
          child: PrimaryButton(
            text: 'Upgrade',
            color: Palette.success,
            icon: Icons.keyboard_arrow_up,
            onPressed: hasResources
                ? () => state.onUpgradeHeadquarters(upgradeCost)
                : null,
            expand: false,
          ),
        ),
      ],
    );
  }
}

class CreateVillagerSection extends StatelessWidget {
  final GameState state;

  const CreateVillagerSection(this.state);

  @override
  Widget build(BuildContext context) {
    final Inventory inventory = state.colony.inventory;
    final ResourceMap villagerCost = state.villagerCost;
    final bool hasResources = inventory.hasResources(villagerCost);
    final List<CreateVillagerTask> tasks =
        state.colony.headquarters.createVillagerTasks;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CostTooltip(
          cost: villagerCost,
          inventory: inventory,
          showInstant: !hasResources,
          child: PrimaryButton(
            text: 'Create Villager',
            color: Palette.success,
            icon: Icons.person,
            onPressed: hasResources
                ? () => state.onAddVillagerQueue(villagerCost)
                : null,
            expand: false,
          ),
        ),
        if (tasks.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: QueueIndicator(
              sprite: ResourceType.villager.sprite,
              progress: tasks[0].progress,
              size: tasks.length,
              onTap: () => state.onRemoveVillagerQueue(villagerCost),
            ),
          )
        else
          const HBox(65),
      ],
    );
  }
}

class HousingSection extends StatelessWidget {
  const HousingSection();

  @override
  Widget build(BuildContext context) {
    return const Label(
      text: 'Houses: 7 → 70',
      color: Palette.white,
      size: 35,
    );
  }
}

class BuildHouseSection extends StatelessWidget {
  final GameState state;

  const BuildHouseSection(this.state);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        PrimaryButton(
          text: 'Build House',
          color: Palette.success,
          icon: Icons.construction,
          onPressed: state.onBuildHouse,
          expand: false,
        ),
        const HBox(20),
        QueueIndicator(
          sprite: BuildingType.house.sprite,
          progress: 0,
          size: 1,
          onTap: state.onRemoveHouseQueue,
        ),
      ],
    );
  }
}
