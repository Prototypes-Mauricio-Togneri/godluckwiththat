import 'package:flutter/material.dart';
import 'package:gatewayguardians/game/game_state.dart';
import 'package:gatewayguardians/models/buildings/building.dart';
import 'package:gatewayguardians/utils/palette.dart';
import 'package:gatewayguardians/widgets/label.dart';

class BuildingMenuHud extends StatelessWidget {
  final GameState state;
  final Building building;

  const BuildingMenuHud({
    required this.state,
    required this.building,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        height: 100,
        color: Palette.grey,
        child: Label(text: building.buildingType.toString()),
      ),
    );
  }
}
