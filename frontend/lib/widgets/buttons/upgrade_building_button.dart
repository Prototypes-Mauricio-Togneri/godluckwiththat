import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/extensions/resource_map_extension.dart';
import 'package:godluckwiththat/models/buildings/building.dart';
import 'package:godluckwiththat/models/resource.dart';
import 'package:godluckwiththat/utils/formatter.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/labels/resource_indicator.dart';

class UpgradeBuildingButton extends StatelessWidget {
  final Building building;

  const UpgradeBuildingButton(this.building);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40,
          height: 40,
          color: Palette.success,
          child: const Center(
            child: Icon(
              Icons.arrow_upward,
              color: Palette.white,
              size: 20,
            ),
          ),
        ),
        const VBox(5),
        for (final Resource resource in building.upgradeCost.resources())
          ResourceIndicator(
            sprite: resource.resourceType.sprite,
            value: Formatter.resource(resource.amount),
            textColor: Palette.black,
            textSize: 15,
            iconSize: 15,
          ),
      ],
    );
  }
}
