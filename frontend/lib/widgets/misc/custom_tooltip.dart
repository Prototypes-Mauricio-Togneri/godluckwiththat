import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/colony.dart';
import 'package:godluckwiththat/types/resource_type.dart';
import 'package:godluckwiththat/utils/formatter.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/labels/label.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

class NewTooltip extends StatelessWidget {
  final List<String> content;
  final Widget child;

  const NewTooltip({
    required this.content,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return JustTheTooltip(
      content: Container(
        constraints: const BoxConstraints(maxWidth: 300),
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final String line in content)
              Label(
                text: line,
                height: 1.5,
                uppercase: false,
              ),
          ],
        ),
      ),
      elevation: 0,
      triggerMode: TooltipTriggerMode.tap,
      waitDuration: const Duration(milliseconds: 500),
      borderRadius: const BorderRadius.all(Radius.circular(0)),
      backgroundColor: Palette.backgroundTooltip,
      tailBaseWidth: 20,
      tailLength: 10,
      child: child,
    );
  }

  factory NewTooltip.uppercase({
    required String content,
    required Widget child,
  }) =>
      NewTooltip(
        content: [content.toUpperCase()],
        child: child,
      );

  factory NewTooltip.storedResource({
    required Colony colony,
    required ResourceType resourceType,
    required Widget child,
  }) {
    final num amount = colony.resources.get(resourceType);
    final num capacity = colony.warehouseCapacity;
    final bool full = amount >= capacity;
    final String production = full
        ? 'Full'.toUpperCase()
        : '${Formatter.production(colony.productionOf(resourceType))}${Formatter.PRODUCTION_RATE_UNIT}';

    return NewTooltip(
      content: [
        resourceType.localized.toUpperCase(),
        '${Formatter.resource(amount)}/${Formatter.resource(capacity)} ($production)',
      ],
      child: child,
    );
  }

  factory NewTooltip.unstoredResource({
    required Colony colony,
    required ResourceType resourceType,
    required Widget child,
  }) {
    final num amount = colony.resources.get(resourceType);
    final String production =
        '${Formatter.production(colony.productionOf(resourceType))}${Formatter.PRODUCTION_RATE_UNIT}';

    return NewTooltip(
      content: [
        resourceType.localized.toUpperCase(),
        '${Formatter.resource(amount)} ($production)',
      ],
      child: child,
    );
  }
}
