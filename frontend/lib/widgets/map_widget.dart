import 'package:flutter/material.dart';
import 'package:gatewayguardians/game/game_state.dart';
import 'package:gatewayguardians/utils/palette.dart';
import 'package:gatewayguardians/widgets/label.dart';

class MapWidget extends StatelessWidget {
  final GameState state;

  const MapWidget(this.state);

  @override
  Widget build(BuildContext context) {
    final double size = MediaQuery.of(context).size.height / 6;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < 5; i++)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int j = 0; j < 5; j++)
                  Container(
                    width: size,
                    height: size,
                    color: Palette.grey,
                    child: Center(
                      child: Label(
                        text: '$i $j',
                        color: Palette.success,
                      ),
                    ),
                  ),
              ],
            )
        ],
      ),
    );
  }
}
