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
          if (zone.patch != null) ...[
            const VBox(20),
            Label(
              text: zone.patch!.toString(),
              size: 16,
              color: Palette.white,
            ),
          ],
          if (zone.status.isUnexplored)
            ZoneUnexplored(
              state: state,
              zone: zone,
            )
          else
            ZoneExplored(
              state: state,
              zone: zone,
            ),
          const VBox(20),
        ],
      ),
    );
  }
}

class ZoneUnexplored extends StatelessWidget {
  final GameState state;
  final Zone zone;

  const ZoneUnexplored({
    required this.state,
    required this.zone,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
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
    );
  }
}

class ZoneExplored extends StatelessWidget {
  final GameState state;
  final Zone zone;

  const ZoneExplored({
    required this.state,
    required this.zone,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (zone.isNeutral) ...[
          if (zone.hasAction)
            Padding(
              padding: const EdgeInsets.only(
                top: 20,
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
          else if (zone.zoneType.canBeClaimed)
            Padding(
              padding: const EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
              ),
              child: PrimaryButton(
                text: 'CLAIM',
                color: Palette.success,
                icon: Icons.flag,
                onPressed: state.colony.hasResource(zone.claimCost)
                    ? () => state.claim(zone)
                    : null,
              ),
            ),
        ] else
          ...[],
      ],
    );
  }
}
