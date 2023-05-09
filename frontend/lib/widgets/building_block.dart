import 'package:flutter/material.dart';
import 'package:gatewayguardians/extensions/resource_map_extension.dart';
import 'package:gatewayguardians/game/game_state.dart';
import 'package:gatewayguardians/models/construction.dart';
import 'package:gatewayguardians/models/patch.dart';
import 'package:gatewayguardians/models/zone.dart';
import 'package:gatewayguardians/types/building_type.dart';
import 'package:gatewayguardians/utils/assets.dart';
import 'package:gatewayguardians/utils/navigation.dart';
import 'package:gatewayguardians/utils/palette.dart';
import 'package:gatewayguardians/widgets/custom_tooltip.dart';
import 'package:gatewayguardians/widgets/image_asset.dart';
import 'package:gatewayguardians/widgets/label.dart';
import 'package:gatewayguardians/widgets/primary_button.dart';

class BuildingBlock extends StatelessWidget {
  final GameState state;
  final Zone zone;
  final Patch patch;
  final BuildingType buildingType;

  const BuildingBlock({
    required this.state,
    required this.zone,
    required this.patch,
    required this.buildingType,
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
          Container(
            width: 150,
            height: 100,
            child: Stack(
              alignment: Alignment.center,
              children: [
                const ImageAsset(
                  path: Assets.IMAGES_BACKGROUNDS_ZONE,
                  width: 150,
                  height: 100,
                ),
                ImageAsset(
                  path: buildingType.sprite,
                  size: 60,
                ),
              ],
            ),
          ),
          CustomTooltip(
            content: Label(
              text: buildingType.cost(1).join(),
              color: Palette.white,
              size: 10,
            ),
            child: PrimaryButton(
              text: 'Build',
              color: Palette.success,
              onPressed: state.colony.inventory.has(buildingType.cost(1))
                  ? _onSelect
                  : null,
              icon: Icons.construction,
              textSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  void _onSelect() {
    Navigation.pop();
    state.onStartConstruction(Construction(
      zone: zone,
      patch: patch,
      buildingType: buildingType,
      toLevel: 1,
    ));
  }
}
