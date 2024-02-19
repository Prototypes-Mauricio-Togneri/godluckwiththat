import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/extensions/resource_map_extension.dart';
import 'package:godluckwiththat/models/buildings/trainers/trainer.dart';
import 'package:godluckwiththat/models/resource.dart';
import 'package:godluckwiththat/utils/formatter.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/buttons/add_remove_button.dart';
import 'package:godluckwiththat/widgets/labels/resource_indicator.dart';

class TrainUnitButton extends StatelessWidget {
  final Trainer trainer;

  const TrainUnitButton(this.trainer);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AddRemoveButton.add(
          size: 40,
          onTap: trainer.canTrain ? trainer.train : null,
        ),
        const VBox(5),
        for (final Resource resource in trainer.trainingCost.resources())
          ResourceIndicator(
            sprite: resource.resourceType.sprite,
            value: Formatter.resource(resource.amount),
            textColor: trainer.colony.inventory.hasResource(resource)
                ? Palette.black
                : Palette.error,
            textSize: 15,
            iconSize: 15,
          ),
      ],
    );
  }
}
