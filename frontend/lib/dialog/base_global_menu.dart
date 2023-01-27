import 'dart:ui';
import 'package:dafluta/dafluta.dart';
import 'package:flutter/widgets.dart';
import 'package:tensionnode/services/palette.dart';

class BaseGlobalMenu extends StatelessWidget {
  final Widget child;

  const BaseGlobalMenu({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Unclosable(
      child: Container(
        color: Palette.screenBackground,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 2,
            sigmaY: 2,
          ),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Palette.grey,
                borderRadius: BorderRadius.circular(5),
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
