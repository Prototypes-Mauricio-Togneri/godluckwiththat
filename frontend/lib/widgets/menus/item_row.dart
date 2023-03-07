import 'package:flutter/material.dart';
import 'package:tensionnode/widgets/resource_icon.dart';

class ItemRow extends StatelessWidget {
  final String title;
  final String sprite;
  final String amount;

  const ItemRow({
    required this.title,
    required this.sprite,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ResourceIcon(
        title: title,
        sprite: sprite,
        amount: amount,
        size: 30,
      ),
    );
  }
}
