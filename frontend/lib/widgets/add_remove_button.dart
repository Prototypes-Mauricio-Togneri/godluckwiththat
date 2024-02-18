import 'package:flutter/material.dart';
import 'package:godluckwiththat/utils/palette.dart';

class AddRemoveButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  final VoidCallback? onTap;

  const AddRemoveButton({
    required this.icon,
    required this.color,
    required this.size,
    required this.onTap,
  });

  factory AddRemoveButton.add({
    required double size,
    required VoidCallback? onTap,
  }) =>
      AddRemoveButton(
        icon: Icons.add,
        color: Palette.success,
        size: size,
        onTap: onTap,
      );

  factory AddRemoveButton.remove({
    required double size,
    required VoidCallback? onTap,
  }) =>
      AddRemoveButton(
        icon: Icons.remove,
        color: Palette.error,
        size: size,
        onTap: onTap,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      color: (onTap != null) ? color : Palette.lightGrey,
      child: Material(
        color: Palette.transparent,
        child: InkWell(
          onTap: onTap,
          child: Center(
            child: Icon(
              icon,
              color: Palette.white,
              size: size * 2 / 3,
            ),
          ),
        ),
      ),
    );
  }
}
