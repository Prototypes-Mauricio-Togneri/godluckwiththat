import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/extensions/resource_map_extension.dart';
import 'package:godluckwiththat/models/buildings/misc/headquarters.dart';
import 'package:godluckwiththat/models/buildings/misc/house.dart';
import 'package:godluckwiththat/models/inventory.dart';
import 'package:godluckwiththat/models/tasks/construction_task.dart';
import 'package:godluckwiththat/models/tasks/create_villager_task.dart';
import 'package:godluckwiththat/states/game_state.dart';
import 'package:godluckwiththat/types/building_type.dart';
import 'package:godluckwiththat/types/resource_type.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/label.dart';
import 'package:godluckwiththat/widgets/primary_button.dart';
import 'package:godluckwiththat/widgets/producer_section.dart';
import 'package:godluckwiththat/widgets/queue_indicator.dart';
import 'package:godluckwiththat/widgets/section_group.dart';
import 'package:godluckwiththat/widgets/tooltip.dart';
import 'package:godluckwiththat/widgets/upgrade_button.dart';

class HeadquartersView extends StatelessWidget {
  final GameState state;

  const HeadquartersView(this.state);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        //UpgradeSection(state),
        CreateVillagerSection(state),
        HousingSection(state),
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

    return SectionGroup(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Label(
            text: 'Town Center level: ${headquarters.level}',
            color: Palette.white,
            size: 35,
          ),
          const HBox(20),
          UpgradeButton(state, headquarters),
        ],
      ),
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
    final List<CreateVillagerTask> tasks =
        state.colony.headquarters.createVillagerTasks;
    final bool maxPopulationReached =
        (inventory.get(ResourceType.villager) + tasks.length) >=
            state.colony.populationLimit;
    final bool canCreateVillager =
        !maxPopulationReached && inventory.hasResources(cost);

    return SectionGroup(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const HBox(65),
          CostTooltip(
            cost: cost,
            inventory: inventory,
            showInstant: !canCreateVillager,
            child: PrimaryButton(
              text: 'Create Villager',
              color: Palette.success,
              icon: Icons.person,
              onPressed: canCreateVillager
                  ? () => state
                      .onAddCreateVillagerTask(CreateVillagerTask(cost: cost))
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
                onTap: () => state.onRemoveCreateVillagerTask(tasks.last),
              ),
            )
          else
            const HBox(65),
        ],
      ),
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
    final Inventory inventory = state.colony.inventory;
    final ResourceMap cost = BuildingType.house.cost(1);
    final List<ConstructionTask> tasks =
        state.colony.getConstructionTasks(BuildingType.house);
    final bool canBuild =
        state.colony.hasFreeVillagers && inventory.hasResources(cost);

    return SectionGroup(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Label(
            text: 'Houses: $amount',
            color: Palette.white,
            size: 35,
          ),
          const VBox(20),
          CostTooltip(
            cost: cost,
            inventory: inventory,
            showInstant: !canBuild,
            child: PrimaryButton(
              text: 'Build House',
              color: Palette.success,
              icon: Icons.construction,
              onPressed: canBuild
                  ? () => state.onAddConstructionTask(ConstructionTask(
                        buildingType: BuildingType.house,
                        resourcesAmount: 0,
                        patch: null,
                      ))
                  : null,
              expand: false,
            ),
          ),
          for (final ConstructionTask task in tasks)
            ConstructionTaskEntry(state, task),
        ],
      ),
    );
  }
}
