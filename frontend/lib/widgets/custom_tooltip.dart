import 'package:flutter/material.dart';
import 'package:gatewayguardians/utils/palette.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

class CustomTooltip extends StatelessWidget {
  final Widget content;
  final Widget child;

  const CustomTooltip({
    required this.content,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return JustTheTooltip(
      backgroundColor: Palette.black,
      borderRadius: const BorderRadius.all(Radius.circular(0)),
      content: Container(
        color: Palette.black,
        padding: const EdgeInsets.all(10),
        child: content,
      ),
      child: child,
    );
  }
}
