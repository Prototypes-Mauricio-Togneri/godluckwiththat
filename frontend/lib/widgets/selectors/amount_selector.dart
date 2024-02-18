import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/widgets/buttons/add_remove_button.dart';
import 'package:godluckwiththat/widgets/labels/label.dart';

class AmountSelector extends StatelessWidget {
  final String text;
  final Color color;
  final double size;
  final VoidCallback? onRemove;
  final VoidCallback? onAdd;

  const AmountSelector({
    required this.text,
    required this.color,
    required this.size,
    required this.onRemove,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AddRemoveButton.remove(
          size: size * 2,
          onTap: onRemove,
        ),
        const HBox(10),
        Label(
          text: text,
          color: color,
          size: size,
        ),
        const HBox(10),
        AddRemoveButton.add(
          size: size * 2,
          onTap: onAdd,
        ),
      ],
    );
  }
}
