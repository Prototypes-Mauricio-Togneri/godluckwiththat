import 'package:flutter/material.dart';
import 'package:godluckwiththat/utils/palette.dart';

class AddRemoveButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const AddRemoveButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  factory AddRemoveButton.add(VoidCallback? onTap) => AddRemoveButton(
        icon: Icons.add,
        color: Palette.success,
        onTap: onTap,
      );

  factory AddRemoveButton.remove(VoidCallback? onTap) => AddRemoveButton(
        icon: Icons.remove,
        color: Palette.error,
        onTap: onTap,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45,
      height: 45,
      color: (onTap != null) ? color : Palette.lightGrey,
      child: Material(
        color: Palette.transparent,
        child: InkWell(
          onTap: onTap,
          child: Center(
            child: Icon(
              icon,
              color: Palette.white,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }
}
