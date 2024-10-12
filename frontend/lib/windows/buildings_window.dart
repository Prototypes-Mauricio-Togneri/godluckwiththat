import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/app/constants.dart';
import 'package:godluckwiththat/models/buildings/building.dart';
import 'package:godluckwiththat/models/buildings/producers/producer.dart';
import 'package:godluckwiththat/states/game_state.dart';
import 'package:godluckwiththat/types/building_type.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/blocks/create_building_block.dart';
import 'package:godluckwiththat/widgets/blocks/passive_building_block.dart';
import 'package:godluckwiththat/widgets/blocks/producer_block.dart';
import 'package:godluckwiththat/widgets/blocks/unavailable_building.dart';
import 'package:godluckwiththat/widgets/tabs/tabbed_container.dart';
import 'package:godluckwiththat/windows/base_window.dart';

class BuildingsWindow extends StatelessWidget {
  final GameState state;

  const BuildingsWindow(this.state);

  @override
  Widget build(BuildContext context) {
    return BaseWindow(
      title: 'Buildings',
      state: state,
      child: Container(
        width: (Constants.BUILDING_BLOCK_WIDTH * 3) + 40,
        height: (Constants.BUILDING_BLOCK_HEIGHT * 2) + 70,
        color: Palette.backgroundWindowTabSelected,
        child: StateProvider<GameState>(
          state: state,
          builder: (context, state) => TabbedContainer(
            tabs: const [
              TabData(title: 'Misc', icon: Icons.business_outlined),
              TabData(title: 'Resources', icon: Icons.home),
              TabData(title: 'Religion', icon: Icons.church),
            ],
            children: [
              BuildingsList(
                state: state,
                buildingTypes: const [
                  [
                    BuildingType.house,
                    BuildingType.academy,
                    BuildingType.storehouse,
                  ],
                  [
                    BuildingType.market,
                  ]
                ],
              ),
              BuildingsList(
                state: state,
                buildingTypes: const [
                  [
                    BuildingType.farm,
                    BuildingType.woodcutter,
                    BuildingType.quarry,
                  ],
                  [
                    BuildingType.copperMine,
                    BuildingType.ironMine,
                    BuildingType.goldMine,
                  ],
                ],
              ),
              BuildingsList(
                state: state,
                buildingTypes: const [
                  [
                    BuildingType.altar,
                    BuildingType.shrine,
                    BuildingType.temple,
                  ],
                  [
                    BuildingType.monument,
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BuildingsList extends StatelessWidget {
  final GameState state;
  final List<List<BuildingType>> buildingTypes;

  const BuildingsList({
    required this.state,
    required this.buildingTypes,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final List<BuildingType> types in buildingTypes)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final BuildingType buildingType in types)
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: _widget(buildingType),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _widget(BuildingType buildingType) {
    if (state.colony.hasBuilding(buildingType)) {
      final Building building = state.colony.getBuilding(buildingType);

      if (building is Producer) {
        return ProducerBlock(building);
      } else {
        return PassiveBuildingBlock(building);
      }
    } else if (state.colony.allowToBuild(buildingType)) {
      return CreateBuildingBlock(
        colony: state.colony,
        buildingType: buildingType,
      );
    } else {
      return UnavailableBuildingBlock(buildingType);
    }
  }
}
