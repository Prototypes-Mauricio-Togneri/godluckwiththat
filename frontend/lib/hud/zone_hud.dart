import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:gatewayguardians/game/game_state.dart';
import 'package:gatewayguardians/hud/building_hud.dart';
import 'package:gatewayguardians/models/zone.dart';
import 'package:gatewayguardians/utils/palette.dart';
import 'package:gatewayguardians/widgets/cancel_button.dart';
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
        if (zone.hasAction)
          CancelButton(
            state: state,
            zone: zone,
            action: zone.actions.first,
          )
        else if (zone.canBeExplored(state.colony))
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
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
        const VBox(20),
        Label(
          text: zone.patch!.toString(),
          size: 16,
          color: Palette.white,
        ),
        if (zone.isNeutral)
          ZoneNeutral(
            state: state,
            zone: zone,
          )
        else
          ZoneOwned(
            state: state,
            zone: zone,
          ),
      ],
    );
  }
}

class ZoneNeutral extends StatelessWidget {
  final GameState state;
  final Zone zone;

  const ZoneNeutral({
    required this.state,
    required this.zone,
  });

  @override
  Widget build(BuildContext context) {
    if (zone.hasAction) {
      return CancelButton(
        state: state,
        zone: zone,
        action: zone.actions.first,
      );
    } else if (zone.zoneType.canBeClaimed) {
      return Padding(
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
      );
    } else {
      return const Empty();
    }
  }
}

class ZoneOwned extends StatelessWidget {
  final GameState state;
  final Zone zone;

  const ZoneOwned({
    required this.state,
    required this.zone,
  });

  @override
  Widget build(BuildContext context) {
    if (zone.building != null) {
      return BuildingHud(
        state: state,
        zone: zone,
        building: zone.building!,
      );
    } else {
      if (zone.hasAction) {
        return CancelButton(
          state: state,
          zone: zone,
          action: zone.actions.first,
        );
      } else {
        return Padding(
          padding: const EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
          ),
          child: PrimaryButton(
            text: 'BUILD',
            color: Palette.success,
            icon: Icons.construction,
            onPressed: state.colony.hasFreeVillagers
                ? () => state.onBuild(zone)
                : null,
          ),
        );
      }
    }
  }
}
