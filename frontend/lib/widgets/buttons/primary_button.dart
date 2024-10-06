import 'package:flutter/material.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/labels/label.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final Color color;
  final VoidCallback? onPressed;
  final double textSize;
  final bool expand;

  const PrimaryButton({
    required this.text,
    required this.color,
    required this.onPressed,
    this.icon,
    this.textSize = 14,
    this.expand = true,
  });

  @override
  Widget build(BuildContext context) {
    return ButtonContent(
      text: text,
      icon: icon,
      color: color,
      onPressed: onPressed,
      textSize: textSize,
      expand: expand,
    );
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
    required this.icon,
    required this.textSize,
    required this.expand,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: expand ? double.infinity : null,
      height: 40,
      color: (onPressed != null) ? color : Palette.buttonDisabled,
      child: Material(
        color: Palette.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: 1,
              left: 10,
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
                      color: Palette.iconLevel1,
                      size: textSize,
                    ),
                  ),
                Label(
                  text: text,
                  size: textSize,
                  color: Palette.textLevel1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
