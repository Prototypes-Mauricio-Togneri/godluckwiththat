import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/game/game_component.dart';
import 'package:tensionnode/widgets/label.dart';
import 'package:tensionnode/widgets/menus/item_row.dart';

class DroneSection extends StatelessWidget {
  final GameComponent game;
  final Node node;

  const DroneSection(this.game, this.node);

  @override
  Widget build(BuildContext context) {
    if (node.availableDrones > 0) {
      return Column(
        children: [
          const VBox(20),
          Label(
            text: 'Drones'.toUpperCase(),
            align: TextAlign.center,
          ),
          const VBox(10),
          ItemRow(
            sprite: game.state.research.droneSprite,
            amount: '${node.availableDrones}',
          ),
        ],
      );
    } else {
      return const Empty();
    }
  }
}
