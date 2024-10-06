import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/utils/navigation.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/labels/label.dart';

class ConfirmationDialog extends StatelessWidget {
  final String message;
  final String buttonAccept;
  final String buttonCancel;
  final VoidCallback onAccept;
  final VoidCallback? onCancel;

  const ConfirmationDialog._({
    required this.message,
    required this.buttonAccept,
    required this.buttonCancel,
    required this.onAccept,
    this.onCancel,
  });

  static DialogController _show({
    required String message,
    required String buttonAccept,
    required String buttonCancel,
    required VoidCallback onAccept,
    VoidCallback? onCancel,
  }) {
    final BuildContext context = Navigation.context;

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Palette.transparent,
      builder: (context) => ConfirmationDialog._(
        message: message,
        buttonAccept: buttonAccept,
        buttonCancel: buttonCancel,
        onAccept: onAccept,
        onCancel: onCancel,
      ),
    );

    return DialogController(context);
  }

  static DialogController clearAllEvents({
    required VoidCallback onAccept,
  }) =>
      _show(
        message: 'Clear all events?',
        buttonAccept: 'Clear',
        buttonCancel: 'Cancel',
        onAccept: onAccept,
      );

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(25, 20, 25, 25),
      backgroundColor: Colors.grey,
      content: Label(
        text: message,
        color: Palette.textLevel1,
        size: 16,
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(
            left: 10,
            right: 10,
            bottom: 10,
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: Palette.buttonPrimary,
              minimumSize: const Size(0, 45),
            ),
            onPressed: () {
              Navigation.pop();
              onCancel?.call();
            },
            child: Label(
              text: buttonCancel,
              size: 14,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            right: 10,
            bottom: 10,
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: Palette.buttonError,
              minimumSize: const Size(0, 45),
            ),
            onPressed: () {
              Navigation.pop();
              onAccept.call();
            },
            child: Label(
              text: buttonAccept,
              size: 14,
            ),
          ),
        ),
      ],
    );
  }
}
