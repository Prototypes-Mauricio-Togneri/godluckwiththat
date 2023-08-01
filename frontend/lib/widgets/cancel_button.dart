import 'package:flutter/material.dart' hide Action;
import 'package:gatewayguardians/game/game_state.dart';
import 'package:gatewayguardians/models/action.dart';
import 'package:gatewayguardians/models/zone.dart';
import 'package:gatewayguardians/utils/palette.dart';
import 'package:gatewayguardians/widgets/primary_button.dart';

class CancelButton extends StatelessWidget {
  final GameState state;
  final Zone zone;
  final Action action;

  const CancelButton({
    required this.state,
    required this.zone,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
      ),
      child: PrimaryButton(
        text: 'CANCEL',
        color: Palette.error,
        icon: Icons.do_not_disturb_on_outlined,
        tooltipError: null,
        onPressed: () => state.cancel(
          zone: zone,
          action: action,
        ),
      ),
    );
  }
}
