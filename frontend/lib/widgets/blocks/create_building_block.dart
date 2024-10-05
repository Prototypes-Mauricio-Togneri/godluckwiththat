import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/app/constants.dart';
import 'package:godluckwiththat/extensions/resource_map_extension.dart';
import 'package:godluckwiththat/models/colony.dart';
import 'package:godluckwiththat/types/building_type.dart';
import 'package:godluckwiththat/utils/formatter.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/buttons/primary_button.dart';
import 'package:godluckwiththat/widgets/labels/resource_indicator.dart';

class CreateBuildingBlock extends StatelessWidget {
  final Colony colony;
  final BuildingType buildingType;

  const CreateBuildingBlock({
    required this.colony,
    required this.buildingType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: Constants.BUILDING_BLOCK_HEIGHT,
      color: Palette.producerBlock,
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PrimaryButton(
            text: 'BUILD ${buildingType.name}',
            color: Palette.success,
            onPressed: colony.canBuild(buildingType)
                ? () => colony.build(buildingType)
                : null,
            icon: Icons.construction,
            expand: false,
          ),
          const VBox(10),
          for (final ResourceMapEntry resource in buildingType.cost(1).entries)
            ResourceIndicator(
              sprite: resource.key.sprite,
              value: Formatter.resource(resource.value),
              textColor: colony.resources.hasItem(resource)
                  ? Palette.black
                  : Palette.error,
              textSize: 14,
              iconSize: 14,
            ),
        ],
      ),
    );
  }
}
