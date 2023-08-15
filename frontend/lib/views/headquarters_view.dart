import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/extensions/resource_map_extension.dart';
import 'package:godluckwiththat/models/buildings/misc/headquarters.dart';
import 'package:godluckwiththat/models/buildings/misc/house.dart';
import 'package:godluckwiththat/models/inventory.dart';
import 'package:godluckwiththat/models/tasks/construct_building.dart';
import 'package:godluckwiththat/models/tasks/create_villager_task.dart';
import 'package:godluckwiththat/models/tasks/upgrade_building_task.dart';
import 'package:godluckwiththat/states/game_state.dart';
import 'package:godluckwiththat/types/building_type.dart';
import 'package:godluckwiththat/types/resource_type.dart';
import 'package:godluckwiththat/utils/assets.dart';
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
        HousingSection(state),
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
    final ResourceMap cost = headquarters.upgradeCost;
    final bool hasResources = inventory.hasResources(cost);
    final UpgradeBuildingTask? task = headquarters.upgradeTask;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Label(
          text: 'Town Center level: ${headquarters.level}',
          color: Palette.white,
          size: 35,
        ),
        const HBox(20),
        CostTooltip(
          cost: cost,
          inventory: inventory,
          showInstant: !hasResources,
          child: PrimaryButton(
            text: 'Upgrade',
            color: Palette.success,
            icon: Icons.person,
            onPressed: (task == null) && hasResources
                ? () => state.onAddUpgradeHeadquarters(cost)
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
              onTap: () => state.onRemoveUpgradeHeadquarters(cost),
            ),
          )
        else
          const HBox(65),
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
    final ResourceMap cost = state.villagerCost;
    final bool hasResources = inventory.hasResources(cost);
    final List<CreateVillagerTask> tasks =
        state.colony.headquarters.createVillagerTasks;
    final bool maxPopulationReached =
        (inventory.get(ResourceType.villager) + tasks.length) >=
            state.colony.populationLimit;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CostTooltip(
          cost: cost,
          inventory: inventory,
          showInstant: !hasResources,
          child: PrimaryButton(
            text: 'Create Villager',
            color: Palette.success,
            icon: Icons.person,
            onPressed: (hasResources && !maxPopulationReached)
                ? () => state.onAddVillagerQueue(cost)
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
              onTap: () => state.onRemoveVillagerQueue(cost),
            ),
          )
        else
          const HBox(65),
      ],
    );
  }
}

class HousingSection extends StatelessWidget {
  final GameState state;

  const HousingSection(this.state);

  @override
  Widget build(BuildContext context) {
    final List<House> houses = state.colony.getBuildings(House);
    final int amount = houses.length;

    if (amount == 0) {
      return const Label(
        text: 'No houses',
        color: Palette.white,
        size: 35,
      );
    } else {
      return Label(
        text: 'Houses: $amount',
        color: Palette.white,
        size: 35,
      );
    }
  }
}

class BuildHouseSection extends StatelessWidget {
  final GameState state;

  const BuildHouseSection(this.state);

  @override
  Widget build(BuildContext context) {
    final Inventory inventory = state.colony.inventory;
    final ResourceMap cost = BuildingType.house.cost(1);
    final bool hasResources = inventory.hasResources(cost);
    final List<ConstructBuildingTask> tasks =
        state.colony.headquarters.buildHouseTasks;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CostTooltip(
          cost: cost,
          inventory: inventory,
          showInstant: !hasResources,
          child: PrimaryButton(
            text: 'Build House',
            color: Palette.success,
            icon: Icons.construction,
            onPressed: hasResources
                ? () => state.onAddConstructBuilding(cost, BuildingType.house)
                : null,
            expand: false,
          ),
        ),
        if (tasks.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: QueueIndicator(
              sprite: BuildingType.house.sprite,
              progress: tasks[0].progress,
              size: tasks.length,
              onTap: () =>
                  state.onRemoveConstructBuilding(cost, BuildingType.house),
            ),
          )
        else
          const HBox(65),
      ],
    );

    /*return Row(
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
    );*/
  }
}
