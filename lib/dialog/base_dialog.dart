import 'dart:ui';
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

  static void show(Widget widget) => Navigation.dialog(widget);

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      autofocus: true,
      focusNode: FocusNode(),
      onKey: onKey,
      child: WillPopScope(
        onWillPop: () async => false,
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
