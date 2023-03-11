import 'package:flutter/material.dart';
import 'package:tensionplanet/widgets/label.dart';

class MenuButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final Color color;
  final VoidCallback onPressed;
  final double topPadding;
  final double size;

  const MenuButton({
    required this.text,
    required this.color,
    required this.onPressed,
    this.icon,
    this.topPadding = 10,
    this.size = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          minimumSize: const Size(0, 45),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Icon(
                  icon,
                  size: 20,
                ),
              ),
            const Spacer(),
            Label(
              text: text.toUpperCase(),
              size: size,
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
