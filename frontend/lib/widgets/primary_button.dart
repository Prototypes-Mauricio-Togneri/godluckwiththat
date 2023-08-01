import 'package:flutter/material.dart';
import 'package:gatewayguardians/utils/palette.dart';
import 'package:gatewayguardians/widgets/custom_tooltip.dart';
import 'package:gatewayguardians/widgets/label.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final Color color;
  final VoidCallback? onPressed;
  final String? tooltipError;
  final double textSize;
  final bool expand;

  const PrimaryButton({
    required this.text,
    required this.color,
    required this.onPressed,
    required this.tooltipError,
    this.icon,
    this.textSize = 14,
    this.expand = true,
  });

  @override
  Widget build(BuildContext context) {
    final Widget button = ButtonContent(
      text: text,
      icon: icon,
      color: color,
      onPressed: onPressed,
      textSize: textSize,
      expand: expand,
    );

    return ((tooltipError != null) && (onPressed == null))
        ? CustomTooltip(
            content: Label(
              text: tooltipError!,
              color: Palette.white,
              size: 12,
            ),
            child: button)
        : button;
  }
}

class ButtonContent extends StatelessWidget {
  final String text;
  final IconData? icon;
  final Color color;
  final VoidCallback? onPressed;
  final double textSize;
  final bool expand;

  const ButtonContent({
    required this.text,
    required this.color,
    required this.onPressed,
    this.icon,
    this.textSize = 14,
    this.expand = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: expand ? double.infinity : 0,
      height: 35,
      color: (onPressed != null) ? color : Palette.lightGrey,
      child: Material(
        color: Palette.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: 1,
              left: 15,
              right: 15,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (icon != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Icon(
                      icon,
                      color: Palette.white,
                      size: textSize * 1.5,
                    ),
                  ),
                Label(
                  text: text.toUpperCase(),
                  size: textSize,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
