import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/buildings/producers/farm.dart';
import 'package:godluckwiththat/states/game_state.dart';
import 'package:godluckwiththat/types/building_type.dart';
import 'package:godluckwiththat/widgets/producer_section.dart';

class FoodView extends StatelessWidget {
  final GameState state;

  const FoodView(this.state);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const VBox(30),
        ProducerSection(
          state: state,
          type: Farm,
          buildingType: BuildingType.farm,
          name: 'Farms',
        ),
      ],
    );
  }
}
