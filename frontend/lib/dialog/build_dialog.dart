import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:gatewayguardians/dialog/window_dialog.dart';
import 'package:gatewayguardians/game/game_state.dart';
import 'package:gatewayguardians/models/zone.dart';
import 'package:gatewayguardians/types/building_type.dart';
import 'package:gatewayguardians/utils/navigation.dart';
import 'package:gatewayguardians/utils/palette.dart';

class BuildDialog extends StatelessWidget {
  final GameState state;
  final Zone zone;

  const BuildDialog._(this.state, this.zone);

  static DialogController show({
    required GameState state,
    required Zone zone,
  }) {
    final BuildContext context = Navigation.context;

    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Palette.transparent,
      builder: (context) => BuildDialog._(state, zone),
    );

    return DialogController(context);
  }

  @override
  Widget build(BuildContext context) {
    return const WindowDialog(
      title: 'Build',
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            /*if (zone.basic().isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final BuildingType buildingType in zone.basic())
                      if (patch.patchType.allowsBuildingType(buildingType))
                        DirectBuild(
                          state: state,
                          zone: zone,
                          patch: patch,
                          buildingType: buildingType,
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
                        DirectBuild(
                          state: state,
                          zone: zone,
                          patch: patch,
                          buildingType: buildingType,
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
                        DirectBuild(
                          state: state,
                          zone: zone,
                          patch: patch,
                          buildingType: buildingType,
                        ),
                  ],
                ),
              ),*/
          ],
        ),
      ),
    );
  }
}

class DirectBuild extends StatelessWidget {
  final GameState state;
  final Zone zone;
  final BuildingType buildingType;

  const DirectBuild({
    required this.state,
    required this.zone,
    required this.buildingType,
  });

  @override
  Widget build(BuildContext context) {
    return const Empty();
  }
}
