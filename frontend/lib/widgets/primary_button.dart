import 'package:flutter/material.dart';
import 'package:tensionplanet/widgets/label.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final Color color;
  final VoidCallback onPressed;
  final double topPadding;
  final double size;
  final bool expand;

  const PrimaryButton({
    required this.text,
    required this.color,
    required this.onPressed,
    this.icon,
    this.topPadding = 10,
    this.size = 14,
    this.expand = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          minimumSize: Size(0, size * 3.5),
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
                  size: size * 1.5,
                ),
              ),
            if (expand) const Spacer(),
            Label(
              text: text,
              size: size,
            ),
            if (expand) const Spacer(),
          ],
        ),
      ),
    );
  }
}
