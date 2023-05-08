import 'package:flutter/material.dart';
import 'package:gatewayguardians/utils/palette.dart';
import 'package:gatewayguardians/widgets/label.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final Color color;
  final VoidCallback onPressed;
  final double textSize;
  final bool expand;

  const PrimaryButton({
    required this.text,
    required this.color,
    required this.onPressed,
    this.icon,
    this.textSize = 12,
    this.expand = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: expand ? double.infinity : null,
      height: 30,
      color: color,
      child: Material(
        color: Palette.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: 1,
              left: 10,
              right: 10,
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
