import 'package:flutter/material.dart';

class Grayscale extends StatelessWidget {
  final Widget child;

  const Grayscale({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: const ColorFilter.matrix([
        0.2, 0.3, 0.4, 0, 0, // red
        0.2, 0.3, 0.4, 0, 0, // green
        0.2, 0.3, 0.4, 0, 0, // blue
        0, 0, 0, 1, 0, //
      ]),
      child: child,
    );
  }
}
