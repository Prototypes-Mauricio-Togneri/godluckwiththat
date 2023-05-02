import 'package:flutter/material.dart';
import 'package:gatewayguardians/game/game_state.dart';
import 'package:gatewayguardians/models/patch.dart';
import 'package:gatewayguardians/utils/palette.dart';
import 'package:gatewayguardians/widgets/label.dart';

class PatchMenuHud extends StatelessWidget {
  final GameState state;
  final Patch patch;

  const PatchMenuHud({
    required this.state,
    required this.patch,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        height: 100,
        color: Palette.grey,
        child: Label(text: patch.patchType.toString()),
      ),
    );
  }
}
