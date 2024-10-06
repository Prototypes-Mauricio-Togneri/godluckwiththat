import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/extensions/resource_map_extension.dart';
import 'package:godluckwiththat/models/buildings/consumers/consumer.dart';
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
        SymbolButton.worker(
          size: 50,
          onTap: consumer.canTrain ? consumer.train : null,
        ),
        const VBox(5),
        for (final ResourceMapEntry resource in consumer.trainingCost.entries)
          ResourceIndicator(
            sprite: resource.key.sprite,
            value: Formatter.resource(resource.value),
            textColor: consumer.colony.resources.hasItem(resource)
                ? Palette.black
                : Palette.error,
            textSize: 14,
            iconSize: 14,
          ),
      ],
    );
  }
}
