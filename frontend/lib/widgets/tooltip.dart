import 'package:flutter/material.dart';
import 'package:godluckwiththat/extensions/resource_map_extension.dart';
import 'package:godluckwiththat/models/inventory.dart';
import 'package:godluckwiththat/models/resource.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/resource_indicator.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

class CustomTooltip extends StatelessWidget {
  final Widget content;
  final Widget child;
  final Duration wait;
  final double padding;

  const CustomTooltip({
    required this.content,
    required this.child,
    this.wait = const Duration(milliseconds: 1000),
    this.padding = 10,
  });

  @override
  Widget build(BuildContext context) {
    return JustTheTooltip(
      backgroundColor: Palette.grey,
      borderRadius: const BorderRadius.all(Radius.circular(0)),
      waitDuration: wait,
      content: Container(
        color: Palette.grey,
        padding: EdgeInsets.all(padding),
        child: content,
      ),
      child: child,
    );
  }
}

class CostTooltip extends StatelessWidget {
  final ResourceMap cost;
  final Inventory inventory;
  final bool showInstant;
  final Widget child;

  const CostTooltip({
    required this.cost,
    required this.inventory,
    required this.showInstant,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTooltip(
      padding: 0,
      wait: showInstant ? Duration.zero : const Duration(milliseconds: 1000),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final Resource resource in cost.resources())
            ResourceIndicator(
              sprite: resource.resourceType.sprite,
              value: resource.amount.toString(),
              textColor: inventory.hasResource(resource)
                  ? Palette.white
                  : Palette.error,
            ),
        ],
      ),
      child: child,
    );
  }
}
