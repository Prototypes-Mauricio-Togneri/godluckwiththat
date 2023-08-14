import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:gatewayguardians/models/tasks/create_villager_task.dart';
import 'package:gatewayguardians/states/game_state.dart';
import 'package:gatewayguardians/types/building_type.dart';
import 'package:gatewayguardians/types/resource_type.dart';
import 'package:gatewayguardians/utils/palette.dart';
import 'package:gatewayguardians/widgets/label.dart';
import 'package:gatewayguardians/widgets/primary_button.dart';
import 'package:gatewayguardians/widgets/queue_indicator.dart';

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
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Label(
          text: 'Town Center level: 3',
          color: Palette.white,
          size: 35,
        ),
        const HBox(20),
        PrimaryButton(
          text: 'Upgrade',
          color: Palette.success,
          icon: Icons.keyboard_arrow_up,
          onPressed: state.onUpgradeHeadquarters,
          tooltipError: null,
          expand: false,
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
    final List<CreateVillagerTask> tasks =
        state.colony.headquarters.createVillagerTasks;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        PrimaryButton(
          text: 'Create Villager',
          color: Palette.success,
          icon: Icons.person,
          onPressed: state.onAddVillagerQueue,
          tooltipError: null,
          expand: false,
        ),
        if (tasks.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: QueueIndicator(
              sprite: ResourceType.villager.sprite,
              progress: tasks[0].progress,
              size: tasks.length,
              onTap: state.onRemoveVillagerQueue,
            ),
          ),
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
          tooltipError: null,
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
