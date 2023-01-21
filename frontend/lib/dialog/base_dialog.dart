import 'dart:ui';
import 'package:dafluta/dafluta.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:tensionnode/services/navigation.dart';
import 'package:tensionnode/services/palette.dart';

class BaseDialog extends StatelessWidget {
  final Widget child;

  const BaseDialog({
    required this.child,
  });

  static void show({
    required Widget widget,
    required String name,
  }) =>
      Navigation.dialog(
        widget: widget,
        name: name,
      );

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      autofocus: true,
      focusNode: FocusNode(),
      onKey: (e) {
        if (e.logicalKey == LogicalKeyboardKey.escape) {
          Navigation.pop();
        }
      },
      child: Unclosable(
        child: Container(
          color: Palette.screenBackground,
          child: SafeArea(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 2,
                sigmaY: 2,
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
