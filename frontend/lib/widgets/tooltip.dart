import 'package:flutter/material.dart';
import 'package:godluckwiththat/extensions/resource_map_extension.dart';
import 'package:godluckwiththat/models/inventory.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/label.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

class CustomTooltip extends StatelessWidget {
  final Widget content;
  final Widget child;
  final Duration wait;

  const CustomTooltip({
    required this.content,
    required this.child,
    this.wait = const Duration(milliseconds: 500),
  });

  @override
  Widget build(BuildContext context) {
    return JustTheTooltip(
      backgroundColor: Palette.grey,
      borderRadius: const BorderRadius.all(Radius.circular(0)),
      waitDuration: wait,
      content: Container(
        color: Palette.grey,
        padding: const EdgeInsets.all(10),
        child: content,
      ),
      child: child,
    );
  }
}

class CostTooltip extends StatelessWidget {
  final ResourceMap cost;
  final Inventory inventory;
  final Widget child;

  const CostTooltip({
    required this.cost,
    required this.inventory,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTooltip(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Label(
            text: cost.toString(),
            color: Palette.white,
            size: 20,
          ),
        ],
      ),
      child: child,
    );
  }
}
