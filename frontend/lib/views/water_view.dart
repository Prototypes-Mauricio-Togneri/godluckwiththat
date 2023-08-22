import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/buildings/producers/well.dart';
import 'package:godluckwiththat/states/game_state.dart';
import 'package:godluckwiththat/types/building_type.dart';
import 'package:godluckwiththat/types/patch_type.dart';
import 'package:godluckwiththat/widgets/producer_section.dart';

class WaterView extends StatelessWidget {
  final GameState state;

  const WaterView(this.state);

  @override
  Widget build(BuildContext context) {
    return ProducerSection(
      state: state,
      type: Well,
      buildingType: BuildingType.well,
      patchType: PatchType.water,
      name: 'Wells',
    );
  }
}
