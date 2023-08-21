import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/buildings/producers/well.dart';
import 'package:godluckwiththat/states/game_state.dart';
import 'package:godluckwiththat/types/building_type.dart';
import 'package:godluckwiththat/widgets/producer_section.dart';

class WaterView extends StatelessWidget {
  final GameState state;

  const WaterView(this.state);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const VBox(30),
        ProducerSection(
          state: state,
          type: Well,
          buildingType: BuildingType.well,
          name: 'Wells',
        ),
      ],
    );
  }
}
