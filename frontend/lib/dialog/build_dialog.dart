import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:gatewayguardians/dialog/window_dialog.dart';
import 'package:gatewayguardians/extensions/resource_map_extension.dart';
import 'package:gatewayguardians/game/game_state.dart';
import 'package:gatewayguardians/models/zone.dart';
import 'package:gatewayguardians/types/building_type.dart';
import 'package:gatewayguardians/utils/assets.dart';
import 'package:gatewayguardians/utils/navigation.dart';
import 'package:gatewayguardians/utils/palette.dart';
import 'package:gatewayguardians/widgets/custom_tooltip.dart';
import 'package:gatewayguardians/widgets/image_asset.dart';
import 'package:gatewayguardians/widgets/label.dart';
import 'package:gatewayguardians/widgets/primary_button.dart';

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
                      DirectBuild(
                        state: state,
                        zone: zone,
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
                      DirectBuild(
                        state: state,
                        zone: zone,
                        buildingType: buildingType,
                      ),
                  ],
                ),
              ),
            /*if (zone.military().isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final BuildingType buildingType in zone.military())
                      DirectBuild(
                        state: state,
                        zone: zone,
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
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: BuildingBlock(
        state: state,
        zone: zone,
        buildingType: buildingType,
        onBuild: () {
          Navigation.pop();
          state.build(
            zone: zone,
            buildingType: buildingType,
          );
        },
      ),
    );
  }
}

class BuildingBlock extends StatelessWidget {
  final GameState state;
  final Zone zone;
  final BuildingType buildingType;
  final VoidCallback onBuild;

  const BuildingBlock({
    required this.state,
    required this.zone,
    required this.buildingType,
    required this.onBuild,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 155,
      color: Palette.grey,
      child: Column(
        children: [
          Container(
            height: 25,
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
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                width: 150,
                height: 130,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const ImageAsset(
                      path: Assets.IMAGES_TILES_GRASS,
                      width: 150,
                      height: 130,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: ImageAsset(
                        path: buildingType.sprite,
                        size: 60,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: CustomTooltip(
                  content: Label(
                    text: buildingType.cost(1).join(),
                    color: Palette.white,
                    size: 10,
                  ),
                  child: PrimaryButton(
                    text: 'Build',
                    color: Palette.success,
                    onPressed: state.colony.inventory.has(buildingType.cost(1))
                        ? onBuild
                        : null,
                    icon: Icons.construction,
                    textSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
