import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/buildings/producers/woodcutter.dart';
import 'package:godluckwiththat/states/game_state.dart';
import 'package:godluckwiththat/types/building_type.dart';
import 'package:godluckwiththat/types/patch_type.dart';
import 'package:godluckwiththat/widgets/producer_section.dart';

class WoodView extends StatelessWidget {
  final GameState state;

  const WoodView(this.state);

  @override
  Widget build(BuildContext context) {
    return ProducerSection(
      state: state,
      type: Woodcutter,
      buildingType: BuildingType.woodcutter,
      patchType: PatchType.wood,
      name: 'Woodcutters',
    );
  }
}
