import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:tensionplanet/dialog/window_dialog.dart';
import 'package:tensionplanet/utils/navigation.dart';
import 'package:tensionplanet/utils/palette.dart';
import 'package:tensionplanet/widgets/label.dart';

class BuildingsDialog extends StatelessWidget {
  const BuildingsDialog._();

  static DialogController show() {
    final BuildContext context = Navigation.context;

    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Palette.transparent,
      builder: (context) => const BuildingsDialog._(),
    );

    return DialogController(context);
  }

  @override
  Widget build(BuildContext context) {
    return WindowDialog(
      title: 'Buildings',
      child: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            VBox(20),
            Label(
              text: 'This is the content',
              color: Palette.white,
              align: TextAlign.center,
            ),
            VBox(20),
          ],
        ),
      ),
    );
  }
}
