import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/buildings/building.dart';
import 'package:godluckwiththat/models/buildings/producers/well.dart';
import 'package:godluckwiththat/states/game_state.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/label.dart';
import 'package:godluckwiththat/widgets/primary_button.dart';

class WaterView extends StatelessWidget {
  final GameState state;

  const WaterView(this.state);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const VBox(30),
        WellSection(state),
      ],
    );
  }
}

class WellSection extends StatelessWidget {
  final GameState state;

  const WellSection(this.state);

  @override
  Widget build(BuildContext context) {
    final List<Well> wells = state.colony.getBuildings(Well);

    if (wells.isEmpty) {
      return const Label(
        text: 'No wells',
        color: Palette.white,
        size: 35,
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Label(
            text: 'Wells',
            color: Palette.white,
            size: 35,
          ),
          const VBox(20),
          for (final Well well in wells) WellEntry(state, well),
        ],
      );
    }
  }
}

class WellEntry extends StatelessWidget {
  final GameState state;
  final Well well;

  const WellEntry(this.state, this.well);

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
          Label(
            text: 'Level: ${well.level}',
            color: Palette.white,
            size: 35,
          ),
          const HBox(50),
          const Label(
            text: 'Workers:',
            color: Palette.white,
            size: 35,
          ),
          const HBox(20),
          WorkersSelector(
            state: state,
            building: well,
          ),
          const HBox(50),
          Label(
            text: 'Production: ${well.production}/day',
            color: Palette.white,
            size: 35,
          ),
          const HBox(50),
          Label(
            text: 'Resources left: ${well.resourcesLeft}',
            color: Palette.white,
            size: 35,
          ),
          const Spacer(),
          PrimaryButton(
            text: 'Destroy',
            expand: false,
            icon: Icons.delete,
            color: Palette.error,
            onPressed: well.destroy,
          ),
        ],
      ),
    );
  }
}

class WorkersSelector extends StatelessWidget {
  final GameState state;
  final Building building;

  const WorkersSelector({
    required this.state,
    required this.building,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        WorkerSelectorButton(
          icon: Icons.remove,
          color: Palette.error,
          onTap: state.canRemoveVillagers(building)
              ? () => state.onRemoveVillager(building)
              : null,
        ),
        const HBox(10),
        Label(
          text: '${building.villagers}/${building.level}',
          color: Palette.white,
          size: 35,
        ),
        const HBox(10),
        WorkerSelectorButton(
          icon: Icons.add,
          color: Palette.success,
          onTap: state.canAddVillagers(building)
              ? () => state.onAddVillager(building)
              : null,
        ),
      ],
    );
  }
}

class WorkerSelectorButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const WorkerSelectorButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45,
      height: 45,
      color: color,
      child: Material(
        color: Palette.transparent,
        child: InkWell(
          onTap: onTap,
          child: Center(
            child: Icon(
              icon,
              color: Palette.white,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }
}
