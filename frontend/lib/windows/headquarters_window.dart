import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/app/constants.dart';
import 'package:godluckwiththat/models/buildings/consumers/headquarters.dart';
import 'package:godluckwiththat/states/game_state.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/buttons/train_unit_button.dart';
import 'package:godluckwiththat/widgets/buttons/upgrade_building_button.dart';
import 'package:godluckwiththat/widgets/images/image_block.dart';
import 'package:godluckwiththat/widgets/labels/label.dart';
import 'package:godluckwiththat/windows/base_window.dart';

class HeadquartersWindow extends StatelessWidget {
  final GameState state;

  const HeadquartersWindow(this.state);

  static DialogController show(GameState state) =>
      BaseWindow.show(HeadquartersWindow(state));

  @override
  Widget build(BuildContext context) {
    return BaseWindow(
      title: 'Headquarters',
      child: Container(
        width: (Constants.BUILDING_BLOCK_WIDTH * 3) + 40,
        height: (Constants.BUILDING_BLOCK_HEIGHT * 2) + 70,
        color: Palette.backgroundWindowTabSelected,
        child: StateProvider<GameState>(
          state: state,
          builder: (context, state) => Content(state),
        ),
      ),
    );
  }
}

class Content extends StatelessWidget {
  final GameState state;

  const Content(this.state);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          TopSection(state.colony.headquarters),
          const VBox(10),
          MiddleSection(state.colony.headquarters),
          const Spacer(),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Label(
          text: headquarters.buildingType.name,
          color: Palette.textLevel2,
          weight: FontWeight.bold,
          size: 14,
        ),
        const VBox(10),
        ImageBlock(
          path: headquarters.buildingType.sprite,
          size: 100,
        ),
      ],
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
