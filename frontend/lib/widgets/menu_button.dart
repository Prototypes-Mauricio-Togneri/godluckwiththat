import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:tensionnode/services/palette.dart';
import 'package:tensionnode/widgets/label.dart';

class MenuButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  final double topPadding;
  final String tooltip;

  const MenuButton({
    required this.text,
    required this.icon,
    required this.color,
    required this.onPressed,
    this.topPadding = 10,
    this.tooltip = '',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: Tooltip(
        message: tooltip,
        waitDuration: const Duration(seconds: 1),
        textStyle: const TextStyle(
          color: Palette.white,
          height: 1.5,
        ),
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
        decoration: BoxDecoration(
          color: Palette.black,
          borderRadius: BorderRadius.circular(5),
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: color,
            minimumSize: const Size(0, 45),
          ),
          onPressed: onPressed,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 20,
              ),
              const HBox(15),
              const Spacer(),
              Label(text: text.toUpperCase()),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
