import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:gatewayguardians/game/game_state.dart';
import 'package:gatewayguardians/models/patch.dart';
import 'package:gatewayguardians/types/building_type.dart';
import 'package:gatewayguardians/types/patch_type.dart';
import 'package:gatewayguardians/utils/palette.dart';
import 'package:gatewayguardians/widgets/building_block.dart';
import 'package:gatewayguardians/widgets/label.dart';
import 'package:gatewayguardians/widgets/primary_button.dart';

class PatchMenuHud extends StatelessWidget {
  final GameState state;
  final Patch patch;

  const PatchMenuHud({
    required this.state,
    required this.patch,
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
              text: patch.patchType.toString(),
              size: 12,
            ),
            const VBox(15),
            if (patch.patchType == PatchType.crop_field)
              BuildingBlock(
                state: state,
                zone: patch.zone,
                patch: patch,
                buildingType: BuildingType.farm,
              )
            else if (patch.patchType == PatchType.forest)
              BuildingBlock(
                state: state,
                zone: patch.zone,
                patch: patch,
                buildingType: BuildingType.woodcutter,
              )
            else if (patch.patchType == PatchType.stone_deposit)
              BuildingBlock(
                state: state,
                zone: patch.zone,
                patch: patch,
                buildingType: BuildingType.quarry,
              )
            else
              PrimaryButton(
                text: 'Build',
                color: Palette.success,
                onPressed: () => state.onBuildOnPatch(patch),
                icon: Icons.construction,
                textSize: 12,
                expand: false,
              ),
          ],
        ),
      ),
    );
  }
}
