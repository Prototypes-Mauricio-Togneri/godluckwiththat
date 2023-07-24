import 'package:flutter/material.dart';
import 'package:gatewayguardians/game/game_state.dart';
import 'package:gatewayguardians/models/zone.dart';
import 'package:gatewayguardians/utils/palette.dart';
import 'package:gatewayguardians/widgets/label.dart';

class ZoneHud extends StatelessWidget {
  final GameState state;
  final Zone zone;

  const ZoneHud({
    required this.state,
    required this.zone,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Label(
          text: zone.id,
          size: 14,
          color: Palette.white,
        ),
      ],
    );
  }
}
