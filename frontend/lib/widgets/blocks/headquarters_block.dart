import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/extensions/resource_map_extension.dart';
import 'package:godluckwiththat/models/buildings/consumers/headquarters.dart';
import 'package:godluckwiththat/states/game_state.dart';
import 'package:godluckwiththat/types/headquarters_type.dart';
import 'package:godluckwiththat/utils/formatter.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/buttons/symbol_button.dart';
import 'package:godluckwiththat/widgets/buttons/train_unit_button.dart';
import 'package:godluckwiththat/widgets/buttons/upgrade_building_button.dart';
import 'package:godluckwiththat/widgets/images/image_block.dart';
import 'package:godluckwiththat/widgets/labels/label.dart';
import 'package:godluckwiththat/widgets/labels/resource_indicator.dart';

class HeadquartersBlock extends StatelessWidget {
  final GameState state;

  const HeadquartersBlock(this.state);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          TopSection(state.colony.headquarters),
          const VBox(20),
          MiddleSection(state.colony.headquarters),
          const VBox(20),
          BottomSection(state.colony.headquarters),
          UpgradeSection(state.colony.headquarters),
        ],
      ),
    );
  }
}

class TopSection extends StatelessWidget {
  final Headquarters headquarters;

  const TopSection(this.headquarters);

  @override
  Widget build(BuildContext context) {
    return ImageBlock(
      path: headquarters.buildingType.sprite,
      size: 100,
    );
  }
}

class MiddleSection extends StatelessWidget {
  final Headquarters headquarters;

  const MiddleSection(this.headquarters);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TrainUnitButton(headquarters),
    );
  }
}

class BottomSection extends StatelessWidget {
  final Headquarters headquarters;

  const BottomSection(this.headquarters);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: UpgradeBuildingButton(headquarters),
    );
  }
}

class UpgradeSection extends StatelessWidget {
  final Headquarters headquarters;

  const UpgradeSection(this.headquarters);

  @override
  Widget build(BuildContext context) {
    final HeadquartersType? nextType = headquarters.type.next;

    if (nextType != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: UpgradeButton(
            headquarters: headquarters,
            nextType: nextType,
          ),
        ),
      );
    } else {
      return const Empty();
    }
  }
}

class UpgradeButton extends StatelessWidget {
  final Headquarters headquarters;
  final HeadquartersType nextType;

  const UpgradeButton({
    required this.headquarters,
    required this.nextType,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SymbolButton.upgradeHeadquarters(
          size: 50,
          onTap: headquarters.canUpgrade ? headquarters.upgrade : null,
        ),
        const HBox(10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Label(
              text: nextType.localized,
              color: Palette.textLevel2,
              weight: FontWeight.bold,
            ),
            for (final ResourceMapEntry resource
                in headquarters.upgradeCost.entries)
              Padding(
                padding: const EdgeInsets.only(top: 7),
                child: ResourceIndicator(
                  sprite: resource.key.sprite,
                  value: Formatter.resource(resource.value),
                  textColor: headquarters.colony.resources.hasItem(resource)
                      ? Palette.textLevel2
                      : Palette.textError,
                  textSize: 12,
                  iconSize: 12,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
