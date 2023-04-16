import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:tensionplanet/game/game_component.dart';
import 'package:tensionplanet/game/game_state.dart';
import 'package:tensionplanet/models/resource.dart';
import 'package:tensionplanet/types/resource_type.dart';
import 'package:tensionplanet/utils/palette.dart';
import 'package:tensionplanet/widgets/image_asset.dart';
import 'package:tensionplanet/widgets/label.dart';

class ResourceHud extends StatelessWidget {
  final GameComponent game;
  final GameState state;

  const ResourceHud({
    required this.game,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ResourceIndicator(state.inventory.resource(ResourceType.food)),
          ResourceIndicator(state.inventory.resource(ResourceType.wood)),
          ResourceIndicator(state.inventory.resource(ResourceType.stone)),
          ResourceIndicator(state.inventory.resource(ResourceType.copper)),
          ResourceIndicator(state.inventory.resource(ResourceType.iron)),
          ResourceIndicator(state.inventory.resource(ResourceType.gold)),
        ],
      ),
    );
  }
}

class ResourceIndicator extends StatelessWidget {
  final Resource resource;

  const ResourceIndicator(this.resource);

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
            path: resource.resourceType.sprite,
            size: 32,
          ),
          const VBox(3),
          Label(
            text: '${resource.amount}',
            size: 12,
          ),
        ],
      ),
    );
  }
}
