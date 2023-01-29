import 'package:flutter/material.dart';
import 'package:tensionnode/services/palette.dart';

class BaseContextualMenu extends StatelessWidget {
  final Widget child;

  const BaseContextualMenu({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Palette.grey,
          borderRadius: BorderRadius.circular(5),
        ),
        child: child,
      ),
    );
  }
}
