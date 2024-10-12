import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/extensions/resource_map_extension.dart';
import 'package:godluckwiththat/models/buildings/consumers/headquarters.dart';
import 'package:godluckwiththat/models/colony.dart';
import 'package:godluckwiththat/states/game_state.dart';
import 'package:godluckwiththat/types/building_type.dart';
import 'package:godluckwiththat/types/headquarters_type.dart';
import 'package:godluckwiththat/utils/formatter.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/buttons/symbol_button.dart';
import 'package:godluckwiththat/widgets/buttons/train_unit_button.dart';
import 'package:godluckwiththat/widgets/buttons/upgrade_building_button.dart';
import 'package:godluckwiththat/widgets/images/image_block.dart';
import 'package:godluckwiththat/widgets/labels/label.dart';
import 'package:godluckwiththat/widgets/labels/resource_indicator.dart';

class HeadquartersBlock extends StatelessWidget {
  final GameState state;

  const HeadquartersBlock(this.state);

  @override
  Widget build(BuildContext context) {
    return StateProvider<GameState>(
      state: state,
      builder: (context, state) => Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BuildingInformation(state.colony.headquarters),
            const HBox(30),
            PopulationInformation(state.colony),
          ],
        ),
      ),
    );
  }
}

class BuildingInformation extends StatelessWidget {
  final Headquarters headquarters;

  const BuildingInformation(this.headquarters);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        TopSection(headquarters),
        const VBox(20),
        MiddleSection(headquarters),
        const VBox(20),
        BottomSection(headquarters),
      ],
    );
  }
}

class TopSection extends StatelessWidget {
  final Headquarters headquarters;

  const TopSection(this.headquarters);

  @override
  Widget build(BuildContext context) {
    return ImageBlock(
      path: headquarters.buildingType.sprite,
      size: 100,
    );
  }
}

class MiddleSection extends StatelessWidget {
  final Headquarters headquarters;

  const MiddleSection(this.headquarters);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TrainUnitButton(
        consumer: headquarters,
        tooltip: 'Create worker',
      ),
    );
  }
}

class BottomSection extends StatelessWidget {
  final Headquarters headquarters;

  const BottomSection(this.headquarters);

  @override
  Widget build(BuildContext context) {
    final HeadquartersType? nextType = headquarters.type.next;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UpgradeBuildingButton(headquarters),
        if (nextType != null) ...[
          const VBox(20),
          UpgradeButton(
            headquarters: headquarters,
            nextType: nextType,
          ),
        ] else
          const Empty(),
      ],
    );
  }
}

class UpgradeButton extends StatelessWidget {
  final Headquarters headquarters;
  final HeadquartersType nextType;

  const UpgradeButton({
    required this.headquarters,
    required this.nextType,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SymbolButton.upgradeHeadquarters(
          size: 50,
          tooltip: 'Upgrade to ${nextType.localized}',
          onTap: headquarters.canImprove ? headquarters.improve : null,
        ),
        const HBox(10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Label(
              text: nextType.localized,
              color: Palette.textLevel2,
              weight: FontWeight.bold,
            ),
            for (final ResourceMapEntry resource
                in headquarters.improveCost.entries)
              Padding(
                padding: const EdgeInsets.only(top: 7),
                child: ResourceIndicator(
                  sprite: resource.key.sprite,
                  value: Formatter.resource(resource.value),
                  textColor: headquarters.colony.resources.hasItem(resource)
                      ? Palette.textLevel2
                      : Palette.textError,
                  textSize: 12,
                  iconSize: 12,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class PopulationInformation extends StatelessWidget {
  final Colony colony;

  const PopulationInformation(this.colony);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InformationRow(
          label: 'Workers',
          value: Formatter.resource(colony.totalWorkers),
        ),
        WorkersForBuilding(
          colony: colony,
          buildingType: BuildingType.farm,
        ),
        WorkersForBuilding(
          colony: colony,
          buildingType: BuildingType.woodcutter,
        ),
        WorkersForBuilding(
          colony: colony,
          buildingType: BuildingType.quarry,
        ),
        WorkersForBuilding(
          colony: colony,
          buildingType: BuildingType.copperMine,
        ),
        WorkersForBuilding(
          colony: colony,
          buildingType: BuildingType.ironMine,
        ),
        WorkersForBuilding(
          colony: colony,
          buildingType: BuildingType.goldMine,
        ),
        WorkersForBuilding(
          colony: colony,
          buildingType: BuildingType.altar,
        ),
        WorkersForBuilding(
          colony: colony,
          buildingType: BuildingType.shrine,
        ),
        WorkersForBuilding(
          colony: colony,
          buildingType: BuildingType.temple,
        ),
        WorkersForBuilding(
          colony: colony,
          buildingType: BuildingType.academy,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: InformationRow(
            label: 'Idle',
            value: Formatter.resource(colony.freeWorkers),
          ),
        ),
      ],
    );
  }
}

class WorkersForBuilding extends StatelessWidget {
  final Colony colony;
  final BuildingType buildingType;

  const WorkersForBuilding({
    required this.colony,
    required this.buildingType,
  });

  @override
  Widget build(BuildContext context) {
    if (colony.hasBuilding(buildingType)) {
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: InformationRow(
          label: buildingType.localized,
          value: Formatter.resource(colony.woodcutter.workers),
        ),
      );
    } else {
      return const Empty();
    }
  }
}

class InformationRow extends StatelessWidget {
  final String label;
  final String value;

  const InformationRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Label(
          text: '$label:',
          color: Palette.textLevel2,
          weight: FontWeight.bold,
        ),
        const HBox(10),
        Label(
          text: value,
          color: Palette.textLevel2,
        ),
      ],
    );
  }
}
