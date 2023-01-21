import 'dart:ui';
import 'package:dafluta/dafluta.dart';
import 'package:flutter/widgets.dart';
import 'package:tensionnode/services/navigation.dart';
import 'package:tensionnode/services/palette.dart';

class BaseDialog extends StatelessWidget {
  final Widget child;
  final Function(RawKeyEvent)? onKey;

  const BaseDialog({
    required this.child,
    this.onKey,
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
      onKey: onKey,
      child: Unclosable(
        child: Container(
          color: Palette.screenBackground,
          child: SafeArea(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 10,
                sigmaY: 10,
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
