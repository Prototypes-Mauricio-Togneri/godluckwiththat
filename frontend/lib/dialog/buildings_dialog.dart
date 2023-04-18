import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:tensionplanet/utils/navigation.dart';
import 'package:tensionplanet/utils/palette.dart';
import 'package:tensionplanet/widgets/label.dart';
import 'package:tensionplanet/widgets/menu_button.dart';

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
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      backgroundColor: Palette.grey,
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Label(
              text: 'TEST',
              color: Palette.white,
              align: TextAlign.center,
            ),
            VBox(20),
            MenuButton(
              text: 'Close',
              color: Palette.lightGrey,
              onPressed: Navigation.pop,
            ),
          ],
        ),
      ),
    );
  }
}
