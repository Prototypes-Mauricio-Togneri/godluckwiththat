import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/extensions/resource_map_extension.dart';
import 'package:godluckwiththat/models/buildings/building.dart';
import 'package:godluckwiththat/models/buildings/producers/producer.dart';
import 'package:godluckwiththat/models/colony.dart';
import 'package:godluckwiththat/states/game_state.dart';
import 'package:godluckwiththat/types/building_type.dart';
import 'package:godluckwiththat/utils/formatter.dart';
import 'package:godluckwiththat/utils/navigation.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/blocks/producer_block.dart';
import 'package:godluckwiththat/widgets/buttons/primary_button.dart';
import 'package:godluckwiththat/widgets/labels/label.dart';
import 'package:godluckwiththat/widgets/labels/resource_indicator.dart';
import 'package:godluckwiththat/windows/base_window.dart';

class BuildingsWindow extends StatelessWidget {
  final GameState state;

  const BuildingsWindow(this.state);

  static DialogController show(GameState state) {
    final BuildContext context = Navigation.context;

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Palette.transparent,
      builder: (context) => BuildingsWindow(state),
    );

    return DialogController(context);
  }

  @override
  Widget build(BuildContext context) {
    return BaseWindow(
      title: 'Buildings',
      child: Container(
        color: Colors.red,
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            BuildingsColumn(
              state: state,
              buildingTypes: const [
                BuildingType.townCenter,
                BuildingType.house,
              ],
            ),
            BuildingsColumn(
              state: state,
              buildingTypes: const [
                BuildingType.farm,
                BuildingType.loggingCamp,
                BuildingType.quarry,
                BuildingType.copperMine,
                BuildingType.ironMine,
                BuildingType.goldMine,
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BuildingsColumn extends StatelessWidget {
  final GameState state;
  final List<BuildingType> buildingTypes;

  const BuildingsColumn({
    required this.state,
    required this.buildingTypes,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final BuildingType buildingType in buildingTypes)
          if (state.colony.hasBuilding(buildingType))
            BuildingBlock(state.colony.buildings[buildingType]!)
          else
            BuildProducerButton(
              colony: state.colony,
              buildingType: buildingType,
            ),
      ],
    );
  }
}

class BuildingBlock extends StatelessWidget {
  final Building building;

  const BuildingBlock(this.building);

  @override
  Widget build(BuildContext context) {
    if (building is Producer) {
      return ProducerBlock(building as Producer);
    } else {
      return Label(text: building.buildingType.name);
    }
  }
}

class BuildProducerButton extends StatelessWidget {
  final Colony colony;
  final BuildingType buildingType;

  const BuildProducerButton({
    required this.colony,
    required this.buildingType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Palette.producerBlock,
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          PrimaryButton(
            text: 'BUILD ${buildingType.name}',
            color: Palette.success,
            onPressed: colony.canBuild(buildingType)
                ? () => colony.build(buildingType)
                : null,
            icon: Icons.construction,
            expand: false,
          ),
          const VBox(10),
          for (final ResourceMapEntry resource in buildingType.cost(1).entries)
            ResourceIndicator(
              sprite: resource.key.sprite,
              value: Formatter.resource(resource.value),
              textColor: colony.resources.hasItem(resource)
                  ? Palette.black
                  : Palette.error,
              textSize: 14,
              iconSize: 14,
            ),
        ],
      ),
    );
  }
}
