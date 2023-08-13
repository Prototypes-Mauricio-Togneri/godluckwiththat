import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:gatewayguardians/states/game_state.dart';
import 'package:gatewayguardians/utils/palette.dart';
import 'package:gatewayguardians/widgets/label.dart';
import 'package:gatewayguardians/widgets/primary_button.dart';

class HeadquartersView extends StatelessWidget {
  final GameState state;

  const HeadquartersView(this.state);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const VBox(30),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Label(
              text: 'Town Center level: 3',
              color: Palette.white,
              size: 35,
            ),
            const HBox(20),
            PrimaryButton(
              text: 'Upgrade',
              color: Palette.success,
              icon: Icons.keyboard_arrow_up,
              onPressed: state.onUpgradeHeadquarters,
              tooltipError: null,
              expand: false,
            ),
          ],
        ),
      ],
    );
  }
}
