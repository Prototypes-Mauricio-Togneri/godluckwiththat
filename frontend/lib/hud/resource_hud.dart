import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:gatewayguardians/game/game_state.dart';
import 'package:gatewayguardians/models/inventory.dart';
import 'package:gatewayguardians/types/resource_type.dart';
import 'package:gatewayguardians/utils/assets.dart';
import 'package:gatewayguardians/utils/palette.dart';
import 'package:gatewayguardians/widgets/custom_tooltip.dart';
import 'package:gatewayguardians/widgets/image_asset.dart';
import 'package:gatewayguardians/widgets/label.dart';

class ResourceHud extends StatelessWidget {
  final GameState state;

  const ResourceHud(this.state);

  @override
  Widget build(BuildContext context) {
    final Inventory inventory = state.colony.inventory;

    return Align(
      alignment: Alignment.topCenter,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (inventory.get(ResourceType.food) > 0)
            ResourceIndicator(
              sprite: ResourceType.food.sprite,
              value: inventory.resource(ResourceType.food).amount.toString(),
              tooltip: 'Food: ${state.colony.productionOf(ResourceType.food)}',
            ),
          if (inventory.get(ResourceType.wood) > 0)
            ResourceIndicator(
              sprite: ResourceType.wood.sprite,
              value: inventory.resource(ResourceType.wood).amount.toString(),
              tooltip: 'Wood: ${state.colony.productionOf(ResourceType.wood)}',
            ),
          if (inventory.get(ResourceType.stone) > 0)
            ResourceIndicator(
              sprite: ResourceType.stone.sprite,
              value: inventory.resource(ResourceType.stone).amount.toString(),
              tooltip:
                  'Stone: ${state.colony.productionOf(ResourceType.stone)}',
            ),
          if (inventory.get(ResourceType.copper) > 0)
            ResourceIndicator(
              sprite: ResourceType.copper.sprite,
              value: inventory.resource(ResourceType.copper).amount.toString(),
              tooltip:
                  'Copper: ${state.colony.productionOf(ResourceType.copper)}',
            ),
          if (inventory.get(ResourceType.iron) > 0)
            ResourceIndicator(
              sprite: ResourceType.iron.sprite,
              value: inventory.resource(ResourceType.iron).amount.toString(),
              tooltip: 'Iron: ${state.colony.productionOf(ResourceType.iron)}',
            ),
          if (inventory.get(ResourceType.gold) > 0)
            ResourceIndicator(
              sprite: ResourceType.gold.sprite,
              value: inventory.resource(ResourceType.gold).amount.toString(),
              tooltip: 'Gold: ${state.colony.productionOf(ResourceType.gold)}',
            ),
          if (inventory.get(ResourceType.villager) > 0)
            ResourceIndicator(
              sprite: ResourceType.villager.sprite,
              value:
                  '${inventory.resource(ResourceType.villager).amount.toString()}/${state.colony.populationLimit}',
              tooltip: 'Population',
            ),
          ResourceIndicator(
            sprite: Assets.IMAGES_RESOURCES_IDLE,
            value: state.colony.freeVillagers.toString(),
            tooltip: 'Idle villagers',
          ),
        ],
      ),
    );
  }
}

class ResourceIndicator extends StatelessWidget {
  final String sprite;
  final String value;
  final String tooltip;

  const ResourceIndicator({
    required this.sprite,
    required this.value,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTooltip(
      content: Label(
        text: tooltip,
        color: Palette.white,
        size: 12,
      ),
      child: Container(
        color: Palette.lightGrey,
        padding: const EdgeInsets.only(
          top: 5,
          bottom: 5,
          left: 15,
          right: 15,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ImageAsset(
              path: sprite,
              size: 32,
            ),
            const VBox(3),
            Label(
              text: value,
              size: 12,
            ),
          ],
        ),
      ),
    );
  }
}
