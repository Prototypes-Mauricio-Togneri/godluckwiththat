import 'package:flutter/material.dart';
import 'package:godluckwiththat/utils/palette.dart';

class SectionGroup extends StatelessWidget {
  final Widget child;

  const SectionGroup({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
      ),
      padding: const EdgeInsets.all(20),
      color: Palette.darkGrey,
      child: child,
    );
  }
}
