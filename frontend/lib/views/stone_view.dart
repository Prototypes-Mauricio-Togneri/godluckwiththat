import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/buildings/producers/quarry.dart';
import 'package:godluckwiththat/states/game_state.dart';
import 'package:godluckwiththat/types/building_type.dart';
import 'package:godluckwiththat/types/patch_type.dart';
import 'package:godluckwiththat/widgets/producer_section.dart';

class StoneView extends StatelessWidget {
  final GameState state;

  const StoneView(this.state);

  @override
  Widget build(BuildContext context) {
    return ProducerSection(
      state: state,
      type: Quarry,
      buildingType: BuildingType.quarry,
      patchType: PatchType.stone,
      name: 'Quarries',
    );
  }
}
