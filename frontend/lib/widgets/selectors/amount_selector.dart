import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/widgets/buttons/symbol_button.dart';
import 'package:godluckwiththat/widgets/images/image_asset.dart';
import 'package:godluckwiththat/widgets/labels/label.dart';

class AmountSelector extends StatelessWidget {
  final String text;
  final Color color;
  final double size;
  final String image;
  final VoidCallback? onRemove;
  final VoidCallback? onAdd;

  const AmountSelector({
    required this.text,
    required this.color,
    required this.size,
    required this.image,
    required this.onRemove,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SymbolButton.remove(
          size: size * 2,
          onTap: onRemove,
        ),
        const HBox(10),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ImageAsset(
              path: image,
              size: size,
            ),
            Label(
              text: text,
              color: color,
              size: size * 0.7,
            ),
          ],
        ),
        const HBox(10),
        SymbolButton.add(
          size: size * 2,
          onTap: onAdd,
        ),
      ],
    );
  }
}
