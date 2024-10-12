import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/buildings/consumers/headquarters.dart';
import 'package:godluckwiththat/states/game_state.dart';
import 'package:godluckwiththat/widgets/buttons/train_unit_button.dart';
import 'package:godluckwiththat/widgets/buttons/upgrade_building_button.dart';
import 'package:godluckwiththat/widgets/images/image_block.dart';

class HeadquartersBlock extends StatelessWidget {
  final GameState state;

  const HeadquartersBlock(this.state);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          TopSection(state.colony.headquarters),
          const VBox(20),
          MiddleSection(state.colony.headquarters),
          const VBox(20),
          BottomSection(state.colony.headquarters),
        ],
      ),
    );
  }
}

class TopSection extends StatelessWidget {
  final Headquarters headquarters;

  const TopSection(this.headquarters);

  @override
  Widget build(BuildContext context) {
    return ImageBlock(
      path: headquarters.buildingType.sprite,
      size: 100,
    );
  }
}

class MiddleSection extends StatelessWidget {
  final Headquarters headquarters;

  const MiddleSection(this.headquarters);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TrainUnitButton(headquarters),
    );
  }
}

class BottomSection extends StatelessWidget {
  final Headquarters headquarters;

  const BottomSection(this.headquarters);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: UpgradeBuildingButton(headquarters),
    );
  }
}
