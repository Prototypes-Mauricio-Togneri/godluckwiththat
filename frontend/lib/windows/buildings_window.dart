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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            BuildingsColumn([
              if (state.colony.hasBuilding(BuildingType.farm))
                state.colony.farm,
              if (state.colony.hasBuilding(BuildingType.loggingCamp))
                state.colony.loggingCamp,
              if (state.colony.hasBuilding(BuildingType.quarry))
                state.colony.quarry,
              if (state.colony.hasBuilding(BuildingType.copperMine))
                state.colony.copperMine,
              if (state.colony.hasBuilding(BuildingType.ironMine))
                state.colony.ironMine,
              if (state.colony.hasBuilding(BuildingType.goldMine))
                state.colony.goldMine,
            ]),
          ],
        ),
      ),
    );
  }
}

class BuildingsColumn extends StatelessWidget {
  final List<Building> buildings;

  const BuildingsColumn(this.buildings);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final Building building in buildings)
          ProducerBlock(building as Producer),
      ],
    );
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
      width: double.infinity,
      color: Palette.producerBlock,
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          PrimaryButton(
            text: 'BUILD',
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
