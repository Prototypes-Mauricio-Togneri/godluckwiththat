import 'package:flutter/material.dart';
import 'package:gatewayguardians/utils/palette.dart';
import 'package:gatewayguardians/widgets/label.dart';

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
    this.textSize = 12,
    this.expand = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: CustomPaint(
        painter: HexShape(color),
        child: SizedBox(
          width: expand ? double.infinity : null,
          height: 30,
          child: ButtonContent(
            text: text,
            icon: icon,
            textSize: textSize,
          ),
        ),
      ),
    );
  }
}

class ButtonContent extends StatelessWidget {
  final String text;
  final IconData? icon;
  final double textSize;

  const ButtonContent({
    required this.text,
    this.icon,
    this.textSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }
}

class HexShape extends CustomPainter {
  final Paint _paint = Paint();

  HexShape(Color color) {
    _paint.color = color;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Path path = Path();
    path.moveTo(0, size.height / 2);
    path.lineTo(size.width * 1 / 8, 0);
    path.lineTo(size.width * 7 / 8, 0);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width * 7 / 8, size.height);
    path.lineTo(size.width * 1 / 8, size.height);
    path.close();

    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
