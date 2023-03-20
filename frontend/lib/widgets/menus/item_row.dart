import 'package:flutter/material.dart';
import 'package:tensionplanet/utils/palette.dart';
import 'package:tensionplanet/widgets/resource_icon.dart';

class ItemRow extends StatelessWidget {
  final String title;
  final String sprite;
  final String amount;
  final Color border;

  const ItemRow({
    required this.title,
    required this.sprite,
    required this.amount,
    this.border = Palette.lightGrey,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ResourceIcon(
        title: title,
        sprite: sprite,
        amount: amount,
        size: 50,
        border: border,
      ),
    );
  }
}
