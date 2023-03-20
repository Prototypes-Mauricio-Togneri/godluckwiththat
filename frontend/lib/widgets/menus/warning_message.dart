import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:tensionplanet/utils/assets.dart';
import 'package:tensionplanet/utils/palette.dart';
import 'package:tensionplanet/widgets/label.dart';

class WarningMessage extends StatelessWidget {
  final String image;
  final String message;

  const WarningMessage._({
    required this.image,
    required this.message,
  });

  factory WarningMessage.notConnected() => const WarningMessage._(
        image: Assets.IMAGES_SIGNS_UNCONNECTED_SIGN,
        message: 'Building not connected',
      );

  factory WarningMessage.idle() => const WarningMessage._(
        image: Assets.IMAGES_SIGNS_IDLE_SIGN,
        message: 'Building not producing',
      );

  factory WarningMessage.outputFilled() => const WarningMessage._(
        image: Assets.IMAGES_SIGNS_FILLED_SIGN,
        message: 'Output queue filled',
      );

  factory WarningMessage.stopped() => const WarningMessage._(
        image: Assets.IMAGES_SIGNS_STOPPED_SIGN,
        message: 'Building stopped',
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      width: double.infinity,
      padding: const EdgeInsets.all(5),
      color: Palette.error,
      child: Row(
        children: [
          const HBox(5),
          SizedBox(
            width: 25,
            height: 25,
            child: Image.asset(
              'images/$image',
            ),
          ),
          const HBox(10),
          Label(
            text: message,
            align: TextAlign.center,
            size: 12,
          ),
        ],
      ),
    );
  }
}
