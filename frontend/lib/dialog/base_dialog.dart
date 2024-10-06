import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/labels/label.dart';

class BaseDialog extends StatelessWidget {
  final String message;
  final List<ActionData> actions;

  const BaseDialog({
    required this.message,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Palette.transparent,
      contentPadding: EdgeInsets.zero,
      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 1000,
          maxHeight: MediaQuery.of(context).size.height - 800,
        ),
        child: Container(
          color: Palette.backgroundWindowContent,
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Message(message),
              const VBox(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: [
                  for (final action in actions) ActionButton(action),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Message extends StatelessWidget {
  final String message;

  const Message(this.message);

  @override
  Widget build(BuildContext context) {
    return Label(
      text: message,
      size: 12,
      color: Palette.textLevel1,
      weight: FontWeight.bold,
    );
  }
}

class ActionButton extends StatelessWidget {
  final ActionData data;

  const ActionButton(this.data);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Material(
        color: data.color,
        child: InkWell(
          onTap: data.onPressed,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Label(
              text: data.text,
              size: 12,
              color: Palette.textLevel1,
            ),
          ),
        ),
      ),
    );
  }
}

class ActionData {
  final String text;
  final Color color;
  final VoidCallback onPressed;

  const ActionData({
    required this.text,
    required this.color,
    required this.onPressed,
  });
}
