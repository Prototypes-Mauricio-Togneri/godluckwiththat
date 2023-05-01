import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:gatewayguardians/dialog/window_dialog.dart';
import 'package:gatewayguardians/game/game_state.dart';
import 'package:gatewayguardians/models/construction.dart';
import 'package:gatewayguardians/models/zone.dart';
import 'package:gatewayguardians/types/building_type.dart';
import 'package:gatewayguardians/types/zone_location.dart';
import 'package:gatewayguardians/utils/assets.dart';
import 'package:gatewayguardians/utils/navigation.dart';
import 'package:gatewayguardians/utils/palette.dart';
import 'package:gatewayguardians/widgets/image_asset.dart';
import 'package:gatewayguardians/widgets/label.dart';
import 'package:gatewayguardians/widgets/primary_button.dart';

class ZoneDialog extends StatelessWidget {
  final GameState state;
  final Zone zone;

  const ZoneDialog._(this.state, this.zone);

  static DialogController show({
    required GameState state,
    required Zone zone,
  }) {
    final BuildContext context = Navigation.context;

    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Palette.transparent,
      builder: (context) => ZoneDialog._(state, zone),
    );

    return DialogController(context);
  }

  @override
  Widget build(BuildContext context) {
    return WindowDialog(
      title: 'Zone ${zone.id}',
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (zone.basic().isNotEmpty)
              Row(
                children: [
                  for (final BuildingType buildingType in zone.basic())
                    BuildingEntry(
                      state: state,
                      zone: zone,
                      buildingType: buildingType,
                    ),
                ],
              ),
            if (zone.producers().isNotEmpty)
              Row(
                children: [
                  for (final BuildingType buildingType in zone.producers())
                    BuildingEntry(
                      state: state,
                      zone: zone,
                      buildingType: buildingType,
                    ),
                ],
              ),
            if (zone.military().isNotEmpty)
              Row(
                children: [
                  for (final BuildingType buildingType in zone.military())
                    BuildingEntry(
                      state: state,
                      zone: zone,
                      buildingType: buildingType,
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class BuildingEntry extends StatelessWidget {
  final GameState state;
  final Zone zone;
  final BuildingType buildingType;

  const BuildingEntry({
    required this.state,
    required this.zone,
    required this.buildingType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 154,
      margin: const EdgeInsets.only(
        right: 10,
        bottom: 10,
      ),
      color: Palette.grey,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(
              top: 5,
              bottom: 5,
              left: 10,
              right: 10,
            ),
            color: Palette.black,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Label(
                  text: buildingType.toString(),
                  size: 10,
                ),
              ],
            ),
          ),
          Container(
            width: 150,
            height: 100,
            child: Stack(
              alignment: Alignment.center,
              children: [
                const ImageAsset(
                  path: Assets.IMAGES_BACKGROUNDS_ZONE,
                  width: 150,
                  height: 150,
                ),
                ImageAsset(
                  path: buildingType.sprite,
                  size: 60,
                ),
              ],
            ),
          ),
          PrimaryButton(
            text: 'Build',
            color: Palette.success,
            onPressed: _onSelect,
            icon: Icons.construction,
            size: 10,
          ),
        ],
      ),
    );
  }

  void _onSelect() {
    Navigation.pop();
    state.onStartConstruction(Construction(
      zone: zone,
      buildingType: buildingType,
      location: ZoneLocation.north, // TODO(momo): select correct location
      toLevel: 1,
    ));
  }
}
