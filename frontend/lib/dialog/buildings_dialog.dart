import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:tensionplanet/components/buildings/building.dart';
import 'package:tensionplanet/dialog/window_dialog.dart';
import 'package:tensionplanet/models/village.dart';
import 'package:tensionplanet/types/building_type.dart';
import 'package:tensionplanet/utils/navigation.dart';
import 'package:tensionplanet/utils/palette.dart';
import 'package:tensionplanet/widgets/image_asset.dart';
import 'package:tensionplanet/widgets/label.dart';

class BuildingsDialog extends StatelessWidget {
  final Village village;

  const BuildingsDialog._(this.village);

  static DialogController show(Village village) {
    final BuildContext context = Navigation.context;

    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Palette.transparent,
      builder: (context) => BuildingsDialog._(village),
    );

    return DialogController(context);
  }

  @override
  Widget build(BuildContext context) {
    return WindowDialog(
      title: 'Buildings',
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                BuildingEntry(
                  buildingType: BuildingType.headquarters,
                  building: village.getBuilding(BuildingType.headquarters),
                ),
                const HBox(10),
                BuildingEntry(
                  buildingType: BuildingType.house,
                  building: village.getBuilding(BuildingType.house),
                ),
                const HBox(10),
                BuildingEntry(
                  buildingType: BuildingType.warehouse,
                  building: village.getBuilding(BuildingType.warehouse),
                ),
                const HBox(10),
                BuildingEntry(
                  buildingType: BuildingType.market,
                  building: village.getBuilding(BuildingType.market),
                ),
              ],
            ),
            const VBox(10),
            Row(
              children: [
                BuildingEntry(
                  buildingType: BuildingType.farm,
                  building: village.getBuilding(BuildingType.farm),
                ),
                const HBox(10),
                BuildingEntry(
                  buildingType: BuildingType.woodcutter,
                  building: village.getBuilding(BuildingType.woodcutter),
                ),
                const HBox(10),
                BuildingEntry(
                  buildingType: BuildingType.quarry,
                  building: village.getBuilding(BuildingType.quarry),
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
  final BuildingType buildingType;
  final Building? building;

  const BuildingEntry({
    required this.buildingType,
    required this.building,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      color: Palette.grey,
      child: Material(
        color: Palette.transparent,
        child: InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Label(
                  text: buildingType.toString(),
                  size: 10,
                ),
                const VBox(10),
                ImageAsset(
                  path: buildingType.sprite,
                  size: 60,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
