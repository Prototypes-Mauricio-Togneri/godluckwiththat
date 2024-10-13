import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/colony.dart';
import 'package:godluckwiththat/types/resource_type.dart';
import 'package:godluckwiththat/utils/formatter.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/labels/label.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

class ComplexTooltip extends StatelessWidget {
  final String title;
  final String content;
  final Widget child;

  const ComplexTooltip({
    required this.title,
    required this.content,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return JustTheTooltip(
      content: Container(
        constraints: const BoxConstraints(maxWidth: 200),
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Label(text: title),
            const VBox(5),
            Label(text: content),
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

  factory ComplexTooltip.storedResource({
    required Colony colony,
    required ResourceType resourceType,
    required Widget child,
  }) {
    final num amount = colony.resources.get(resourceType);
    final num capacity = colony.warehouseCapacity;
    final bool full = amount >= capacity;
    final String production = full
        ? 'FULL'
        : '${Formatter.production(colony.productionOf(resourceType))}/s';

    return ComplexTooltip(
      title: resourceType.localized,
      content:
          '${Formatter.resource(amount)}/${Formatter.resource(capacity)} ($production)',
      child: child,
    );
  }

  factory ComplexTooltip.unstoredResource({
    required Colony colony,
    required ResourceType resourceType,
    required Widget child,
  }) {
    final num amount = colony.resources.get(resourceType);
    final String production =
        '${Formatter.production(colony.productionOf(resourceType))}/s';

    return ComplexTooltip(
      title: resourceType.localized,
      content: '${Formatter.resource(amount)} ($production)',
      child: child,
    );
  }
}

class SimpleTooltip extends StatelessWidget {
  final String content;
  final Widget child;

  const SimpleTooltip({
    required this.content,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return JustTheTooltip(
      content: Container(
        constraints: const BoxConstraints(maxWidth: 300),
        padding: const EdgeInsets.all(10),
        child: Label(text: content),
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

  factory SimpleTooltip.resource({
    required ResourceType resourceType,
    required Widget child,
  }) =>
      SimpleTooltip(
        content: resourceType.localized,
        child: child,
      );
}
