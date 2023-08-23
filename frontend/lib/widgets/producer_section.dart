import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/dialog/confirmation_dialog.dart';
import 'package:godluckwiththat/dialog/create_exploration_dialog.dart';
import 'package:godluckwiththat/extensions/resource_map_extension.dart';
import 'package:godluckwiththat/models/buildings/producers/producer.dart';
import 'package:godluckwiththat/models/inventory.dart';
import 'package:godluckwiththat/models/patch.dart';
import 'package:godluckwiththat/models/tasks/exploration_task.dart';
import 'package:godluckwiththat/states/game_state.dart';
import 'package:godluckwiththat/types/building_type.dart';
import 'package:godluckwiththat/types/patch_type.dart';
import 'package:godluckwiththat/utils/assets.dart';
import 'package:godluckwiththat/utils/formatter.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/image_asset.dart';
import 'package:godluckwiththat/widgets/label.dart';
import 'package:godluckwiththat/widgets/primary_button.dart';
import 'package:godluckwiththat/widgets/tooltip.dart';
import 'package:godluckwiththat/widgets/upgrade_button.dart';
import 'package:godluckwiththat/widgets/workers_selector.dart';

class ProducerSection extends StatelessWidget {
  final GameState state;
  final Type type;
  final BuildingType buildingType;
  final PatchType patchType;
  final String name;

  const ProducerSection({
    required this.state,
    required this.type,
    required this.buildingType,
    required this.patchType,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PatchesSection(
          state: state,
          patchType: patchType,
        ),
        BuildingsSection(
          state: state,
          type: type,
          buildingType: buildingType,
          name: name,
        ),
        ExplorationSection(state, patchType),
      ],
    );
  }
}

class PatchesSection extends StatelessWidget {
  final GameState state;
  final PatchType patchType;

  const PatchesSection({
    required this.state,
    required this.patchType,
  });

  @override
  Widget build(BuildContext context) {
    final List<Patch> patches = state.colony.getPatches(patchType);

    if (patches.isEmpty) {
      return const Empty();
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const VBox(20),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ImageAsset(
                path: patchType.sprite,
                size: 40,
              ),
              const HBox(10),
              const Label(
                text: 'Patches',
                color: Palette.white,
                size: 35,
              ),
            ],
          ),
          const VBox(20),
          for (final Patch patch in patches) PatchEntry(state, patch),
        ],
      );
    }
  }
}

class PatchEntry extends StatelessWidget {
  final GameState state;
  final Patch patch;

  const PatchEntry(this.state, this.patch);

  @override
  Widget build(BuildContext context) {
    final ResourceMap cost = patch.patchType.buildingType.initialCost;
    final Inventory inventory = state.colony.inventory;
    final bool hasResources = inventory.hasResources(cost);

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
            text: 'Amount: ${patch.amount}',
            color: Palette.white,
            size: 30,
          ),
          const Spacer(),
          CostTooltip(
            cost: cost,
            inventory: inventory,
            showInstant: !hasResources,
            child: PrimaryButton(
              text: 'Build',
              expand: false,
              icon: Icons.construction,
              color: Palette.success,
              onPressed: () => state.colony.hasFreeVillagers
                  ? state.onAddConstructionFromPatchTask(patch)
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

class BuildingsSection extends StatelessWidget {
  final GameState state;
  final Type type;
  final BuildingType buildingType;
  final String name;

  const BuildingsSection({
    required this.state,
    required this.type,
    required this.buildingType,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    final List<Producer> buildings = state.colony.getBuildings(type);

    if (buildings.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Label(
          text: 'No $name',
          color: Palette.white,
          size: 35,
        ),
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const VBox(20),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ImageAsset(
                path: buildingType.sprite,
                size: 40,
              ),
              const HBox(10),
              Label(
                text: name,
                color: Palette.white,
                size: 35,
              ),
            ],
          ),
          const VBox(20),
          for (final Producer producer in buildings)
            BuildingEntry(state, producer),
        ],
      );
    }
  }
}

class BuildingEntry extends StatelessWidget {
  final GameState state;
  final Producer producer;

  const BuildingEntry(this.state, this.producer);

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
            text: 'Level: ${producer.level}',
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
          WorkersSelector(
            building: producer,
            size: 30,
          ),
          const HBox(30),
          Label(
            text: 'Production: ${producer.production}/day',
            color: (producer.production > 0) ? Palette.success : Palette.error,
            size: 30,
          ),
          const HBox(30),
          Label(
            text: producer.hasResourcesLeft
                ? 'Resources left: ${Formatter.resource(producer.resourcesLeft)}'
                : 'Depleted',
            color: producer.hasResourcesLeft ? Palette.white : Palette.error,
            size: 30,
          ),
          const HBox(30),
          UpgradeButton(state, producer),
          const Spacer(),
          PrimaryButton(
            text: 'Destroy',
            expand: false,
            icon: Icons.delete,
            color: Palette.error,
            onPressed: producer.destroy,
          ),
        ],
      ),
    );
  }
}

class ExplorationSection extends StatelessWidget {
  final GameState state;
  final PatchType patchType;

  const ExplorationSection(this.state, this.patchType);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const VBox(20),
        const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ImageAsset(
              path: Assets.IMAGES_OTHER_EXPLORATION,
              size: 40,
            ),
            HBox(10),
            Label(
              text: 'Explorations',
              color: Palette.white,
              size: 35,
            ),
          ],
        ),
        const VBox(20),
        for (final ExplorationTask task in state.colony.explorationTasks)
          ExplorationTaskEntry(state, task),
        const VBox(20),
        PrimaryButton(
          text: 'Explore',
          expand: false,
          icon: Icons.explore,
          color: Palette.success,
          onPressed: () => CreateExplorationDialog.show(
            patchType: patchType,
            state: state,
          ),
        ),
      ],
    );
  }
}

class ExplorationTaskEntry extends StatelessWidget {
  final GameState state;
  final ExplorationTask task;

  const ExplorationTaskEntry(this.state, this.task);

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
            text: 'Villagers: ${task.villagers}',
            color: Palette.white,
            size: 30,
          ),
          const HBox(30),
          Label(
            text: 'Days: ${task.days}',
            color: Palette.white,
            size: 30,
          ),
          const HBox(30),
          Label(
            text: 'Progress: ${Formatter.progress(task.progress)}',
            color: Palette.white,
            size: 30,
          ),
          const Spacer(),
          PrimaryButton(
            text: 'Stop',
            expand: false,
            icon: Icons.cancel,
            color: Palette.error,
            onPressed: _onCancel,
          ),
        ],
      ),
    );
  }

  void _onCancel() => ConfirmationDialog.cancelExploration(
        onAccept: () => state.onRemoveExplorationTask(task),
      );
}
