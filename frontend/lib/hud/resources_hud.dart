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
        const VBox(10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ResourceIndicator(
              sprite: ResourceType.food.sprite,
              value: inventory.get(ResourceType.food).toString(),
              tooltip:
                  'Food: ${state.colony.productionOf(ResourceType.food)} / min',
            ),
            ResourceIndicator(
              sprite: ResourceType.wood.sprite,
              value: inventory.get(ResourceType.wood).toString(),
              tooltip:
                  'Wood: ${state.colony.productionOf(ResourceType.wood)} / min',
            ),
            ResourceIndicator(
              sprite: ResourceType.stone.sprite,
              value: inventory.get(ResourceType.stone).toString(),
              tooltip:
                  'Stone: ${state.colony.productionOf(ResourceType.stone)} / min',
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
                  'Copper: ${state.colony.productionOf(ResourceType.copper)} / min',
            ),
            ResourceIndicator(
              sprite: ResourceType.iron.sprite,
              value: inventory.get(ResourceType.iron).toString(),
              tooltip:
                  'Iron: ${state.colony.productionOf(ResourceType.iron)} / min',
            ),
            ResourceIndicator(
              sprite: ResourceType.gold.sprite,
              value: inventory.get(ResourceType.gold).toString(),
              tooltip:
                  'Gold: ${state.colony.productionOf(ResourceType.gold)} / min',
            ),
          ],
        ),*/
      ],
    );
  }
}

class ResourceIndicator extends StatelessWidget {
  final String sprite;
  final String value;
  final String tooltip;
  final Color textColor;

  const ResourceIndicator({
    required this.sprite,
    required this.value,
    required this.tooltip,
    this.textColor = Palette.white,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTooltip(
      content: Label(
        text: tooltip,
        color: Palette.white,
        size: 12,
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 5,
          bottom: 5,
          left: 20,
          right: 20,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ImageAsset(
              path: sprite,
              size: 28,
            ),
            const HBox(10),
            Label(
              text: value,
              size: 14,
              color: textColor,
            ),
          ],
        ),
      ),
    );
  }
}
