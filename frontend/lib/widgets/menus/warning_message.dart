import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:tensionplanet/utils/palette.dart';
import 'package:tensionplanet/widgets/label.dart';

class WarningMessage extends StatelessWidget {
  final String message;

  const WarningMessage(this.message);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      width: double.infinity,
      padding: const EdgeInsets.all(5),
      color: Palette.error,
      child: Row(
        children: [
          const HBox(10),
          const Icon(
            Icons.warning,
            color: Palette.white,
            size: 15,
          ),
          const HBox(10),
          Label(
            text: message.toUpperCase(),
            align: TextAlign.center,
            size: 12,
          ),
        ],
      ),
    );
  }
}
