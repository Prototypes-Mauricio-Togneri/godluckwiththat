import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:gatewayguardians/game/game_state.dart';
import 'package:gatewayguardians/models/buildings/building.dart';
import 'package:gatewayguardians/models/zone.dart';
import 'package:gatewayguardians/utils/palette.dart';
import 'package:gatewayguardians/widgets/label.dart';

class BuildingHud extends StatelessWidget {
  final GameState state;
  final Zone zone;
  final Building building;

  const BuildingHud({
    required this.state,
    required this.zone,
    required this.building,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const VBox(20),
          Label(
            text: building.buildingType.toString(),
            size: 16,
            color: Palette.white,
          ),
          const VBox(20),
          Label(
            text: 'LEVEL ${building.level}',
            size: 14,
            color: Palette.white,
          ),
          const VBox(20),
          Label(
            text: 'VILLAGERS ${building.workers}',
            size: 14,
            color: Palette.white,
          ),
          if (building.isProducer) ...[
            const VBox(20),
            Label(
              text:
                  '${building.resourcesPerTurn} ${building.buildingType.produces.toString()}/turn',
              size: 14,
              color: Palette.white,
            ),
          ]
        ],
      ),
    );
  }
}
