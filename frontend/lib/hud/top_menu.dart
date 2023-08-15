import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/inventory.dart';
import 'package:godluckwiththat/states/game_state.dart';
import 'package:godluckwiththat/types/resource_type.dart';
import 'package:godluckwiththat/utils/formatter.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/label.dart';
import 'package:godluckwiththat/widgets/resource_indicator.dart';

class TopMenu extends StatelessWidget {
  final GameState state;

  const TopMenu(this.state);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Palette.darkGrey,
      width: double.infinity,
      child: ResourcesHud(state),
    );
  }
}

class ResourcesHud extends StatelessWidget {
  final GameState state;

  const ResourcesHud(this.state);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PopulationBlock(state),
        const HBox(30),
        ResourceBlock(
          state: state,
          resourceType: ResourceType.water,
        ),
        const HBox(30),
        ResourceBlock(
          state: state,
          resourceType: ResourceType.food,
        ),
        const HBox(30),
        ResourceBlock(
          state: state,
          resourceType: ResourceType.wood,
        ),
        const HBox(30),
        ResourceBlock(
          state: state,
          resourceType: ResourceType.stone,
        ),
      ],
    );
  }
}

class PopulationBlock extends StatelessWidget {
  final GameState state;

  const PopulationBlock(this.state);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ResourceIndicator(
          sprite: ResourceType.villager.sprite,
          value:
              '${state.colony.inventory.get(ResourceType.villager)}/${state.colony.populationLimit}',
          tooltip: 'Population',
        ),
        SizedBox(
          height: 30,
          child: Center(
            child: Label(
              text: '${state.colony.freeVillagers.toString()} idle',
              color: Palette.white,
              size: 25,
            ),
          ),
        ),
      ],
    );
  }
}

class ResourceBlock extends StatelessWidget {
  final GameState state;
  final ResourceType resourceType;

  const ResourceBlock({
    required this.state,
    required this.resourceType,
  });

  @override
  Widget build(BuildContext context) {
    final Inventory inventory = state.colony.inventory;
    final double production = state.colony.productionOf(resourceType);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ResourceIndicator(
          sprite: resourceType.sprite,
          value: inventory.get(resourceType).toString(),
          tooltip: resourceType.toString(),
        ),
        SizedBox(
          height: 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                (production >= 0)
                    ? Icons.arrow_drop_up_sharp
                    : Icons.arrow_drop_down_sharp,
                color: (production >= 0) ? Palette.success : Palette.error,
                size: 30,
              ),
              Label(
                text: '${Formatter.production(production)}/day',
                color: Palette.white,
                size: 25,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
