import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/extensions/resource_map_extension.dart';
import 'package:godluckwiththat/models/colony.dart';
import 'package:godluckwiththat/types/building_type.dart';
import 'package:godluckwiththat/utils/formatter.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/buttons/symbol_button.dart';
import 'package:godluckwiththat/widgets/labels/label.dart';
import 'package:godluckwiththat/widgets/labels/resource_indicator.dart';

class CreateBuildingButton extends StatelessWidget {
  final Colony colony;
  final BuildingType buildingType;

  const CreateBuildingButton({
    required this.colony,
    required this.buildingType,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SymbolButton.build(
          size: 50,
          tooltip: 'Build ${buildingType.localized}',
          onTap: colony.canBuild(buildingType)
              ? () => colony.build(buildingType)
              : null,
        ),
        const HBox(10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Label(
              text: 'Build',
              color: Palette.textLevel2,
              weight: FontWeight.bold,
            ),
            for (final ResourceMapEntry resource
                in buildingType.cost(1).entries)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: ResourceIndicator(
                  sprite: resource.key.sprite,
                  value: Formatter.resource(resource.value),
                  textColor: colony.resources.hasItem(resource)
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
