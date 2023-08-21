import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/buildings/producers/well.dart';
import 'package:godluckwiththat/states/game_state.dart';
import 'package:godluckwiththat/types/building_type.dart';
import 'package:godluckwiththat/types/resource_type.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/amount_selector.dart';
import 'package:godluckwiththat/widgets/label.dart';
import 'package:godluckwiththat/widgets/primary_button.dart';
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
        const Spacer(),
        const ExplorationSection(resourceType: ResourceType.food),
      ],
    );
  }
}

class ExplorationSection extends StatelessWidget {
  final ResourceType resourceType;

  const ExplorationSection({
    required this.resourceType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 20,
        left: 20,
        right: 20,
      ),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: Palette.lightGrey,
        ),
      ),
      child: Row(
        children: [
          const Label(
            text: 'Villagers:',
            color: Palette.white,
            size: 30,
          ),
          const HBox(20),
          AmountSelector(
            text: '1',
            color: Palette.white,
            size: 30,
            onRemove: () {},
            onAdd: () {},
          ),
          const HBox(30),
          const Label(
            text: 'Days:',
            color: Palette.white,
            size: 30,
          ),
          const HBox(20),
          AmountSelector(
            text: '1',
            color: Palette.white,
            size: 30,
            onRemove: () {},
            onAdd: () {},
          ),
          const HBox(30),
          const Spacer(),
          PrimaryButton(
            text: 'Explore',
            expand: false,
            icon: Icons.explore,
            color: Palette.success,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
