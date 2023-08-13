import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:gatewayguardians/game/game_state.dart';
import 'package:gatewayguardians/models/inventory.dart';
import 'package:gatewayguardians/types/resource_type.dart';
import 'package:gatewayguardians/utils/assets.dart';
import 'package:gatewayguardians/utils/formatter.dart';
import 'package:gatewayguardians/utils/palette.dart';
import 'package:gatewayguardians/widgets/label.dart';
import 'package:gatewayguardians/widgets/resource_indicator.dart';

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
    final Inventory inventory = state.colony.inventory;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const VBox(10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
        ),
        const VBox(10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ResourceIndicator(
              sprite: ResourceType.villager.sprite,
              value:
                  '${inventory.get(ResourceType.villager)}/${state.colony.populationLimit}',
              tooltip: 'Population',
              textColor: (inventory.get(ResourceType.villager) ==
                      state.colony.populationLimit)
                  ? Palette.error
                  : Palette.white,
            ),
            ResourceIndicator(
              sprite: Assets.IMAGES_RESOURCES_IDLE,
              value: state.colony.freeVillagers.toString(),
              tooltip: 'Idle villagers',
            ),
          ],
        ),
        /*Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ResourceIndicator(
              sprite: ResourceType.copper.sprite,
              value: inventory.get(ResourceType.copper).toString(),
              tooltip:
                  'Copper: ${state.colony.productionOf(ResourceType.copper)} / turn',
            ),
            ResourceIndicator(
              sprite: ResourceType.iron.sprite,
              value: inventory.get(ResourceType.iron).toString(),
              tooltip:
                  'Iron: ${state.colony.productionOf(ResourceType.iron)} / turn',
            ),
            ResourceIndicator(
              sprite: ResourceType.gold.sprite,
              value: inventory.get(ResourceType.gold).toString(),
              tooltip:
                  'Gold: ${state.colony.productionOf(ResourceType.gold)} / turn',
            ),
          ],
        ),*/
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
    final double production = state.colony.productionOf(ResourceType.food);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ResourceIndicator(
          sprite: resourceType.sprite,
          value: inventory.get(resourceType).toString(),
          tooltip: resourceType.toString(),
        ),
        const VBox(5),
        Row(
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
      ],
    );
  }
}
