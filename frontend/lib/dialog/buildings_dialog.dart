import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:tensionplanet/dialog/window_dialog.dart';
import 'package:tensionplanet/game/game_state.dart';
import 'package:tensionplanet/models/buildings/building.dart';
import 'package:tensionplanet/models/construction.dart';
import 'package:tensionplanet/types/building_type.dart';
import 'package:tensionplanet/utils/assets.dart';
import 'package:tensionplanet/utils/navigation.dart';
import 'package:tensionplanet/utils/palette.dart';
import 'package:tensionplanet/widgets/image_asset.dart';
import 'package:tensionplanet/widgets/label.dart';
import 'package:tensionplanet/widgets/primary_button.dart';

class BuildingsDialog extends StatelessWidget {
  final GameState state;

  const BuildingsDialog._(this.state);

  static DialogController show(GameState state) {
    final BuildContext context = Navigation.context;

    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Palette.transparent,
      builder: (context) => BuildingsDialog._(state),
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
                  state: state,
                  buildingType: BuildingType.headquarters,
                ),
                const HBox(10),
                BuildingEntry(
                  state: state,
                  buildingType: BuildingType.house,
                ),
                const HBox(10),
                BuildingEntry(
                  state: state,
                  buildingType: BuildingType.warehouse,
                ),
                const HBox(10),
                BuildingEntry(
                  state: state,
                  buildingType: BuildingType.market,
                ),
              ],
            ),
            const VBox(10),
            Row(
              children: [
                BuildingEntry(
                  state: state,
                  buildingType: BuildingType.farm,
                ),
                const HBox(10),
                BuildingEntry(
                  state: state,
                  buildingType: BuildingType.woodcutter,
                ),
                const HBox(10),
                BuildingEntry(
                  state: state,
                  buildingType: BuildingType.quarry,
                ),
                const HBox(10),
                BuildingEntry(
                  state: state,
                  buildingType: BuildingType.copper_mine,
                ),
                const HBox(10),
                BuildingEntry(
                  state: state,
                  buildingType: BuildingType.iron_mine,
                ),
                const HBox(10),
                BuildingEntry(
                  state: state,
                  buildingType: BuildingType.gold_mine,
                ),
              ],
            ),
            const VBox(10),
            Row(
              children: [
                BuildingEntry(
                  state: state,
                  buildingType: BuildingType.barracks,
                ),
                const HBox(10),
                BuildingEntry(
                  state: state,
                  buildingType: BuildingType.archery,
                ),
                const HBox(10),
                BuildingEntry(
                  state: state,
                  buildingType: BuildingType.cavalry,
                ),
                const HBox(10),
                BuildingEntry(
                  state: state,
                  buildingType: BuildingType.workshop,
                ),
                const HBox(10),
                BuildingEntry(
                  state: state,
                  buildingType: BuildingType.fortress,
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
  final BuildingType buildingType;
  late final Building? building;
  late final int level;

  BuildingEntry({
    required this.state,
    required this.buildingType,
  }) {
    building = state.currentVillage.getBuilding(buildingType);
    level = building?.level ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 158,
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
                Expanded(
                  child: Label(
                    text: buildingType.toString(),
                    size: 10,
                  ),
                ),
                Label(
                  text: '$level',
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
            onPressed: _onSelect,
            icon: (building != null)
                ? Icons.keyboard_double_arrow_up_sharp
                : Icons.construction,
            size: 10,
          ),
        ],
      ),
    );
  }

  void _onSelect() {
    Navigation.pop();
    state.onStartConstruction(Construction(
      state: state,
      village: state.currentVillage,
      buildingType: buildingType,
      toLevel: level + 1,
    ));
  }
}
