import 'package:flutter/material.dart';
import 'package:gatewayguardians/extensions/resource_map_extension.dart';
import 'package:gatewayguardians/game/game_state.dart';
import 'package:gatewayguardians/models/zone.dart';
import 'package:gatewayguardians/utils/palette.dart';
import 'package:gatewayguardians/widgets/custom_tooltip.dart';
import 'package:gatewayguardians/widgets/label.dart';
import 'package:gatewayguardians/widgets/primary_button.dart';

class ZoneMenuHud extends StatelessWidget {
  final GameState state;
  final Zone zone;

  const ZoneMenuHud({
    required this.state,
    required this.zone,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.all(20),
        color: Palette.blackOverlay,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Label(
              text: zone.isOwned ? 'Owned' : 'Not owned',
              size: 12,
            ),
            if (zone.status.isUnexplored)
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: CustomTooltip(
                  content: Label(
                    text: zone.explorationCost().join(),
                    color: Palette.white,
                    size: 10,
                  ),
                  child: PrimaryButton(
                    text: 'Explore',
                    color: Palette.success,
                    onPressed:
                        state.colony.inventory.has(zone.explorationCost())
                            ? () => state.onExploreZone(zone)
                            : null,
                    icon: Icons.explore,
                    textSize: 12,
                    expand: false,
                  ),
                ),
              )
            else if (!zone.isOwned)
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: CustomTooltip(
                  content: Label(
                    text: zone.conquerCost().join(),
                    color: Palette.white,
                    size: 10,
                  ),
                  child: PrimaryButton(
                    text: 'Conquer',
                    color: Palette.success,
                    onPressed: state.colony.inventory.has(zone.conquerCost())
                        ? () => state.onExploreZone(zone)
                        : null,
                    icon: Icons.flag,
                    textSize: 12,
                    expand: false,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
