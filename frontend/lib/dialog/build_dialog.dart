import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:gatewayguardians/dialog/window_dialog.dart';
import 'package:gatewayguardians/game/game_state.dart';
import 'package:gatewayguardians/models/patch.dart';
import 'package:gatewayguardians/models/zone.dart';
import 'package:gatewayguardians/types/building_type.dart';
import 'package:gatewayguardians/utils/navigation.dart';
import 'package:gatewayguardians/utils/palette.dart';
import 'package:gatewayguardians/widgets/building_block.dart';

class BuildDialog extends StatelessWidget {
  final GameState state;
  final Patch patch;

  const BuildDialog._(this.state, this.patch);

  static DialogController show({
    required GameState state,
    required Patch patch,
  }) {
    final BuildContext context = Navigation.context;

    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Palette.transparent,
      builder: (context) => BuildDialog._(state, patch),
    );

    return DialogController(context);
  }

  @override
  Widget build(BuildContext context) {
    final Zone zone = patch.zone;

    return WindowDialog(
      title: 'Build',
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (zone.basic().isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final BuildingType buildingType in zone.basic())
                      if (patch.patchType.allowsBuildingType(buildingType))
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: BuildingBlock(
                            state: state,
                            zone: zone,
                            patch: patch,
                            buildingType: buildingType,
                          ),
                        ),
                  ],
                ),
              ),
            if (zone.producers().isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final BuildingType buildingType in zone.producers())
                      if (patch.patchType.allowsBuildingType(buildingType))
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: BuildingBlock(
                            state: state,
                            zone: zone,
                            patch: patch,
                            buildingType: buildingType,
                          ),
                        ),
                  ],
                ),
              ),
            if (zone.military().isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final BuildingType buildingType in zone.military())
                      if (patch.patchType.allowsBuildingType(buildingType))
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: BuildingBlock(
                            state: state,
                            zone: zone,
                            patch: patch,
                            buildingType: buildingType,
                          ),
                        ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
