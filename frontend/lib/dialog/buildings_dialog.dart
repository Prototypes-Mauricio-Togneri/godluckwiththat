import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:tensionplanet/components/buildings/building.dart';
import 'package:tensionplanet/dialog/window_dialog.dart';
import 'package:tensionplanet/models/village.dart';
import 'package:tensionplanet/types/building_type.dart';
import 'package:tensionplanet/utils/assets.dart';
import 'package:tensionplanet/utils/navigation.dart';
import 'package:tensionplanet/utils/palette.dart';
import 'package:tensionplanet/widgets/image_asset.dart';
import 'package:tensionplanet/widgets/label.dart';
import 'package:tensionplanet/widgets/primary_button.dart';

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
                const HBox(10),
                BuildingEntry(
                  buildingType: BuildingType.copper_mine,
                  building: village.getBuilding(BuildingType.copper_mine),
                ),
                const HBox(10),
                BuildingEntry(
                  buildingType: BuildingType.iron_mine,
                  building: village.getBuilding(BuildingType.iron_mine),
                ),
                const HBox(10),
                BuildingEntry(
                  buildingType: BuildingType.gold_mine,
                  building: village.getBuilding(BuildingType.gold_mine),
                ),
              ],
            ),
            const VBox(10),
            Row(
              children: [
                BuildingEntry(
                  buildingType: BuildingType.barracks,
                  building: village.getBuilding(BuildingType.barracks),
                ),
                const HBox(10),
                BuildingEntry(
                  buildingType: BuildingType.archery,
                  building: village.getBuilding(BuildingType.archery),
                ),
                const HBox(10),
                BuildingEntry(
                  buildingType: BuildingType.cavalry,
                  building: village.getBuilding(BuildingType.cavalry),
                ),
                const HBox(10),
                BuildingEntry(
                  buildingType: BuildingType.workshop,
                  building: village.getBuilding(BuildingType.workshop),
                ),
                const HBox(10),
                BuildingEntry(
                  buildingType: BuildingType.fortress,
                  building: village.getBuilding(BuildingType.fortress),
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
      height: 158,
      color: Palette.grey,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            color: Palette.black,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Label(
                    text: buildingType.toString(),
                    size: 10,
                  ),
                ),
                Label(
                  text: (building != null) ? '${building!.level}' : '0',
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
                  path: Assets.IMAGES_BACKGROUNDS_VILLAGE,
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
            text: (building != null) ? 'Level up' : 'Build',
            color: (building != null) ? Palette.primary : Palette.success,
            onPressed: () {},
            icon: (building != null)
                ? Icons.keyboard_double_arrow_up_sharp
                : Icons.construction,
            size: 10,
          ),
        ],
      ),
    );
  }
}
