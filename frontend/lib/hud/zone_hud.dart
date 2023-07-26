import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:gatewayguardians/game/game_state.dart';
import 'package:gatewayguardians/models/zone.dart';
import 'package:gatewayguardians/utils/palette.dart';
import 'package:gatewayguardians/widgets/label.dart';
import 'package:gatewayguardians/widgets/primary_button.dart';

class ZoneHud extends StatelessWidget {
  final GameState state;
  final Zone zone;

  const ZoneHud({
    required this.state,
    required this.zone,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      width: double.infinity,
      color: Palette.blackOverlay,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const VBox(20),
          Label(
            text: zone.id,
            size: 16,
            color: Palette.white,
          ),
          if (zone.status.isExplored) ...[
            const VBox(20),
            Label(
              text: zone.zoneType.toString(),
              size: 14,
              color: Palette.white,
            ),
          ],
          if (zone.patches.isNotEmpty) ...[
            const VBox(20),
            Label(
              text: zone.patches.map((e) => e.toString()).join(', '),
              size: 16,
              color: Palette.white,
            ),
          ],
          if (zone.status.isUnexplored) ...[
            const VBox(20),
            if (zone.hasAction)
              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                ),
                child: PrimaryButton(
                  text: 'CANCEL',
                  color: Palette.error,
                  icon: Icons.close,
                  onPressed: () => state.cancel(zone),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                ),
                child: PrimaryButton(
                  text: 'EXPLORE',
                  color: Palette.success,
                  icon: Icons.explore_outlined,
                  onPressed: state.colony.hasFreeVillagers &&
                          state.colony.hasResource(zone.explorationCost)
                      ? () => state.explore(zone)
                      : null,
                ),
              ),
          ],
          const VBox(20),
        ],
      ),
    );
  }
}
