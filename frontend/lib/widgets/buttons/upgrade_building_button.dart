import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/extensions/resource_map_extension.dart';
import 'package:godluckwiththat/models/buildings/building.dart';
import 'package:godluckwiththat/utils/formatter.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/buttons/symbol_button.dart';
import 'package:godluckwiththat/widgets/labels/label.dart';
import 'package:godluckwiththat/widgets/labels/resource_indicator.dart';

class UpgradeBuildingButton extends StatelessWidget {
  final Building building;

  const UpgradeBuildingButton(this.building);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SymbolButton.upgrade(
          size: 50,
          onTap: building.canUpgrade ? building.upgrade : null,
        ),
        const HBox(10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Label(
              text: 'LEVEL ${building.level + 1}',
              color: Palette.textLevel2,
              weight: FontWeight.bold,
            ),
            for (final ResourceMapEntry resource
                in building.upgradeCost.entries)
              Padding(
                padding: const EdgeInsets.only(top: 7),
                child: ResourceIndicator(
                  sprite: resource.key.sprite,
                  value: Formatter.resource(resource.value),
                  textColor: building.colony.resources.hasItem(resource)
                      ? Palette.textLevel2
                      : Palette.error,
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
