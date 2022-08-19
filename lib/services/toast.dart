import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:tensionnode/services/palette.dart';
import 'package:tensionnode/widgets/label.dart';

class Toast {
  static void error({
    required BuildContext context,
    required String text,
  }) =>
      MotionToast(
        icon: Icons.error,
        primaryColor: Palette.red,
        title: Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Label(
            text: text,
            color: Palette.black,
          ),
        ),
        description: const Empty(),
        borderRadius: 5,
        constraints: const BoxConstraints(
          minHeight: 50,
          minWidth: 50,
          maxHeight: 50,
        ),
        animationDuration: Duration.zero,
      ).show(context);
}
