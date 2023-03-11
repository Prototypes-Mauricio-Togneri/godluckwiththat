import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:tensionplanet/utils/navigation.dart';
import 'package:tensionplanet/utils/palette.dart';
import 'package:tensionplanet/widgets/label.dart';

class ConfirmationDialog extends StatelessWidget {
  final String message;
  final String buttonAccept;
  final String buttonCancel;
  final VoidCallback onAccept;
  final VoidCallback onCancel;

  const ConfirmationDialog._({
    required this.message,
    required this.buttonAccept,
    required this.buttonCancel,
    required this.onAccept,
    required this.onCancel,
  });

  static DialogController _show({
    required BuildContext context,
    required String message,
    required String buttonAccept,
    required String buttonCancel,
    required VoidCallback onAccept,
    VoidCallback? onCancel,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ConfirmationDialog._(
        message: message,
        buttonAccept: buttonAccept,
        buttonCancel: buttonCancel,
        onAccept: onAccept,
        onCancel: onCancel ?? () {},
      ),
    );

    return DialogController(context);
  }

  static DialogController destroyBuilding({
    required BuildContext context,
    required VoidCallback onAccept,
  }) =>
      _show(
        context: context,
        message: 'Destroy building?',
        buttonAccept: 'Destroy',
        buttonCancel: 'Cancel',
        onAccept: onAccept,
      );

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(25, 20, 25, 25),
      backgroundColor: Palette.grey,
      content: Label(
        text: message.toUpperCase(),
        color: Palette.white,
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Palette.primary,
            minimumSize: const Size(0, 45),
          ),
          onPressed: () {
            Navigation.pop();
            onCancel.call();
          },
          child: Label(
            text: buttonCancel.toUpperCase(),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Palette.error,
            minimumSize: const Size(0, 45),
          ),
          onPressed: () {
            Navigation.pop();
            onAccept.call();
          },
          child: Label(
            text: buttonAccept.toUpperCase(),
          ),
        ),
      ],
    );
  }
}
