import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/dialog/base_dialog.dart';
import 'package:godluckwiththat/utils/navigation.dart';
import 'package:godluckwiththat/utils/palette.dart';

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
    return BaseDialog(
      message: message,
      actions: [
        ActionData(
          text: buttonCancel,
          color: Palette.buttonPrimary,
          onPressed: () {
            Navigation.pop();
            onCancel?.call();
          },
        ),
        ActionData(
          text: buttonAccept,
          color: Palette.buttonError,
          onPressed: () {
            Navigation.pop();
            onAccept.call();
          },
        ),
      ],
    );
  }
}
