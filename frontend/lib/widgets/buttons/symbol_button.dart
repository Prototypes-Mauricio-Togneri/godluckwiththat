import 'package:flutter/material.dart';
import 'package:godluckwiththat/utils/assets.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/images/image_asset.dart';
import 'package:godluckwiththat/widgets/images/image_grayscale.dart';
import 'package:godluckwiththat/widgets/misc/custom_tooltip.dart';

class SymbolButton extends StatelessWidget {
  final Color color;
  final double size;
  final String tooltip;
  final VoidCallback? onTap;
  final IconData? icon;
  final String? sprite;

  const SymbolButton({
    required this.color,
    required this.size,
    required this.tooltip,
    required this.onTap,
    this.icon,
    this.sprite,
  });

  factory SymbolButton.add({
    required double size,
    required String tooltip,
    required VoidCallback? onTap,
  }) =>
      SymbolButton(
        icon: Icons.add,
        color: Palette.buttonEnabled,
        size: size,
        tooltip: tooltip,
        onTap: onTap,
      );

  factory SymbolButton.worker({
    required double size,
    required String tooltip,
    required VoidCallback? onTap,
  }) =>
      SymbolButton(
        sprite: Assets.IMAGES_UNITS_WORKER,
        color: Palette.buttonEnabled,
        size: size,
        tooltip: tooltip,
        onTap: onTap,
      );

  factory SymbolButton.remove({
    required double size,
    required String tooltip,
    required VoidCallback? onTap,
  }) =>
      SymbolButton(
        icon: Icons.remove,
        color: Palette.buttonError,
        size: size,
        tooltip: tooltip,
        onTap: onTap,
      );

  factory SymbolButton.upgrade({
    required double size,
    required String tooltip,
    required VoidCallback? onTap,
  }) =>
      SymbolButton(
        icon: Icons.arrow_upward,
        color: Palette.buttonEnabled,
        size: size,
        tooltip: tooltip,
        onTap: onTap,
      );

  factory SymbolButton.upgradeHeadquarters({
    required double size,
    required String tooltip,
    required VoidCallback? onTap,
  }) =>
      SymbolButton(
        icon: Icons.home,
        color: Palette.buttonEnabled,
        size: size,
        tooltip: tooltip,
        onTap: onTap,
      );

  factory SymbolButton.build({
    required double size,
    required String tooltip,
    required VoidCallback? onTap,
  }) =>
      SymbolButton(
        icon: Icons.construction,
        color: Palette.buttonEnabled,
        size: size,
        tooltip: tooltip,
        onTap: onTap,
      );

  @override
  Widget build(BuildContext context) {
    final double dimensions = size * 2 / 3;
    final Widget image = (icon != null)
        ? Icon(
            icon,
            color: Palette.iconLevel1,
            size: dimensions,
          )
        : ImageAsset(
            path: sprite!,
            size: dimensions,
          );

    return NewTooltip.uppercase(
      content: tooltip,
      child: Container(
        width: size,
        height: size,
        color: (onTap != null) ? color : Palette.buttonDisabled,
        child: Material(
          color: Palette.transparent,
          child: InkWell(
            onTap: onTap,
            child: Center(
              child: (onTap != null) ? image : Grayscale(child: image),
            ),
          ),
        ),
      ),
    );
  }
}
