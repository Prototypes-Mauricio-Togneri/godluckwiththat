import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/buildings/building.dart';
import 'package:godluckwiththat/models/buildings/producers/producer.dart';
import 'package:godluckwiththat/states/game_state.dart';
import 'package:godluckwiththat/types/building_type.dart';
import 'package:godluckwiththat/utils/navigation.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/blocks/create_building_block.dart';
import 'package:godluckwiththat/widgets/blocks/producer_block.dart';
import 'package:godluckwiththat/widgets/labels/label.dart';
import 'package:godluckwiththat/widgets/tabs/tabbed_container.dart';
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
        width: 400,
        height: 600,
        color: Colors.red,
        child: TabbedContainer(
          tabs: const [
            TabData(title: 'Misc', icon: Icons.business_outlined),
            TabData(title: 'Resources', icon: Icons.home),
          ],
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
            CreateBuildingBlock(
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
