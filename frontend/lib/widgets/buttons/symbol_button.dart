import 'package:flutter/material.dart';
import 'package:godluckwiththat/utils/assets.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/misc/image_asset.dart';

class SymbolButton extends StatelessWidget {
  final Color color;
  final double size;
  final VoidCallback? onTap;
  final IconData? icon;
  final String? sprite;

  const SymbolButton({
    required this.color,
    required this.size,
    required this.onTap,
    this.icon,
    this.sprite,
  });

  factory SymbolButton.add({
    required double size,
    required VoidCallback? onTap,
  }) =>
      SymbolButton(
        icon: Icons.add,
        color: Palette.success,
        size: size,
        onTap: onTap,
      );

  factory SymbolButton.villager({
    required double size,
    required VoidCallback? onTap,
  }) =>
      SymbolButton(
        sprite: Assets.IMAGES_UNITS_VILLAGER,
        color: Palette.success,
        size: size,
        onTap: onTap,
      );

  factory SymbolButton.remove({
    required double size,
    required VoidCallback? onTap,
  }) =>
      SymbolButton(
        icon: Icons.remove,
        color: Palette.error,
        size: size,
        onTap: onTap,
      );

  factory SymbolButton.upgrade({
    required double size,
    required VoidCallback? onTap,
  }) =>
      SymbolButton(
        icon: Icons.arrow_upward,
        color: Palette.success,
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
            child: (icon != null)
                ? Icon(
                    icon,
                    color: Palette.white,
                    size: size * 2 / 3,
                  )
                : ImageAsset(
                    path: sprite!,
                    size: size * 2 / 3,
                  ),
          ),
        ),
      ),
    );
  }
}
