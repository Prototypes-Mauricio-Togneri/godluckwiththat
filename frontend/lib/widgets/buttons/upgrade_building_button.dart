import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/extensions/resource_map_extension.dart';
import 'package:godluckwiththat/models/buildings/building.dart';
import 'package:godluckwiththat/utils/formatter.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/buttons/symbol_button.dart';
import 'package:godluckwiththat/widgets/labels/resource_indicator.dart';

class UpgradeBuildingButton extends StatelessWidget {
  final Building building;

  const UpgradeBuildingButton(this.building);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SymbolButton.upgrade(
          size: 40,
          onTap: building.canUpgrade ? building.upgrade : null,
        ),
        const VBox(5),
        for (final ResourceMapEntry resource in building.upgradeCost.entries)
          ResourceIndicator(
            sprite: resource.key.sprite,
            value: Formatter.resource(resource.value),
            textColor: building.colony.resourceInventory.hasItem(resource)
                ? Palette.black
                : Palette.error,
            textSize: 15,
            iconSize: 15,
          ),
      ],
    );
  }
}
