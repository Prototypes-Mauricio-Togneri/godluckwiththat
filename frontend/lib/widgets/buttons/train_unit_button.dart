import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/extensions/item_map_extension.dart';
import 'package:godluckwiththat/models/buildings/consumers/consumer.dart';
import 'package:godluckwiththat/models/resource.dart';
import 'package:godluckwiththat/utils/formatter.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/buttons/symbol_button.dart';
import 'package:godluckwiththat/widgets/labels/resource_indicator.dart';

class TrainUnitButton extends StatelessWidget {
  final Consumer consumer;

  const TrainUnitButton(this.consumer);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SymbolButton.villager(
          size: 40,
          onTap: consumer.canTrain ? consumer.train : null,
        ),
        const VBox(5),
        for (final Resource resource in consumer.trainingCost.resources())
          ResourceIndicator(
            sprite: resource.resourceType.sprite,
            value: Formatter.resource(resource.amount),
            textColor: consumer.colony.inventory.hasResource(resource)
                ? Palette.black
                : Palette.error,
            textSize: 15,
            iconSize: 15,
          ),
      ],
    );
  }
}
