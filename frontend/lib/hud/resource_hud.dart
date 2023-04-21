import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:tensionplanet/game/game_state.dart';
import 'package:tensionplanet/models/inventory.dart';
import 'package:tensionplanet/types/resource_type.dart';
import 'package:tensionplanet/utils/assets.dart';
import 'package:tensionplanet/utils/palette.dart';
import 'package:tensionplanet/widgets/image_asset.dart';
import 'package:tensionplanet/widgets/label.dart';

class ResourceHud extends StatelessWidget {
  final GameState state;

  const ResourceHud(this.state);

  @override
  Widget build(BuildContext context) {
    final Inventory inventory = state.currentVillage.inventory;

    return Align(
      alignment: Alignment.topCenter,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (inventory.get(ResourceType.food) > 0)
            ResourceIndicator(
              sprite: ResourceType.food.sprite,
              value: inventory.resource(ResourceType.food).amount.toString(),
            ),
          if (inventory.get(ResourceType.wood) > 0)
            ResourceIndicator(
              sprite: ResourceType.wood.sprite,
              value: inventory.resource(ResourceType.wood).amount.toString(),
            ),
          if (inventory.get(ResourceType.stone) > 0)
            ResourceIndicator(
              sprite: ResourceType.stone.sprite,
              value: inventory.resource(ResourceType.stone).amount.toString(),
            ),
          if (inventory.get(ResourceType.copper) > 0)
            ResourceIndicator(
              sprite: ResourceType.copper.sprite,
              value: inventory.resource(ResourceType.copper).amount.toString(),
            ),
          if (inventory.get(ResourceType.iron) > 0)
            ResourceIndicator(
              sprite: ResourceType.iron.sprite,
              value: inventory.resource(ResourceType.iron).amount.toString(),
            ),
          if (inventory.get(ResourceType.gold) > 0)
            ResourceIndicator(
              sprite: ResourceType.gold.sprite,
              value: inventory.resource(ResourceType.gold).amount.toString(),
            ),
          if (inventory.get(ResourceType.villager) > 0)
            ResourceIndicator(
              sprite: ResourceType.villager.sprite,
              value:
                  '${inventory.resource(ResourceType.villager).amount.toString()}/${state.currentVillage.populationLimit}',
            ),
          ResourceIndicator(
            sprite: Assets.IMAGES_HUD_IDLE,
            value: state.currentVillage.freeVillagers.toString(),
          ),
        ],
      ),
    );
  }
}

class ResourceIndicator extends StatelessWidget {
  final String sprite;
  final String value;

  const ResourceIndicator({
    required this.sprite,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
