import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:gatewayguardians/game/game_state.dart';
import 'package:gatewayguardians/models/buildings/building.dart';
import 'package:gatewayguardians/models/buildings/producers/producer.dart';
import 'package:gatewayguardians/utils/palette.dart';
import 'package:gatewayguardians/widgets/label.dart';
import 'package:gatewayguardians/widgets/primary_button.dart';

class BuildingHud extends StatelessWidget {
  final GameState state;
  final Building building;

  const BuildingHud({
    required this.state,
    required this.building,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const VBox(20),
          Label(
            text: building.buildingType.toString(),
            size: 16,
            color: Palette.white,
          ),
          const VBox(20),
          Label(
            text: 'LEVEL ${building.level}',
            size: 14,
            color: Palette.white,
          ),
          if (building.isProducer)
            ProducerBlock(
              state: state,
              building: building,
            ),
        ],
      ),
    );
  }
}

class ProducerBlock extends StatelessWidget {
  final GameState state;
  final Building building;

  const ProducerBlock({
    required this.state,
    required this.building,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const VBox(20),
        Label(
          text:
              '${(building as Producer).resourcesPerTurn} ${building.buildingType.produces}/turn',
          size: 14,
          color: Palette.white,
        ),
        const VBox(20),
        const Label(
          text: 'VILLAGERS ASSIGNED:',
          size: 14,
          color: Palette.white,
        ),
        const VBox(20),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            VillagerButton(
              color: Palette.error,
              onTap: building.hasVillagers
                  ? () => state.removeVillager(building)
                  : null,
              icon: Icons.remove,
            ),
            const HBox(20),
            Label(
              text: '${building.villagers}',
              size: 20,
              color: Palette.white,
            ),
            const HBox(20),
            VillagerButton(
              color: Palette.success,
              onTap: (state.colony.hasFreeVillagers &&
                      building.canHaveMoreVillagers)
                  ? () => state.addVillager(building)
                  : null,
              icon: Icons.add,
            ),
          ],
        ),
      ],
    );
  }
}

class TrainerBlock extends StatelessWidget {
  final GameState state;

  const TrainerBlock({
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        VBox(20),
        /*Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
          ),
          child: PrimaryButton(
            text: 'CREATE VILLAGER',
            color: Palette.success,
            icon: Icons.person,
            tooltipError: island.trainVillagerCost.join(),
            onPressed: state.colony.hasResources(island.trainVillagerCost)
                ? () => state.trainVillager(island)
                : null,
          ),
        ),
        for (final Action action in island.actions)
          QueuedAction(
            text: 'CREATE VILLAGER',
            onTap: () => state.cancel(
              island: island,
              action: action,
            ),
          ),*/
      ],
    );
  }
}

class VillagerButton extends StatelessWidget {
  final Color color;
  final VoidCallback? onTap;
  final IconData icon;

  const VillagerButton({
    required this.color,
    required this.onTap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: (onTap != null) ? color : Palette.lightGrey,
      child: Material(
        color: Palette.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(10),
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

class QueuedAction extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;

  const QueuedAction({
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
      ),
      child: PrimaryButton(
        text: text.toUpperCase(),
        color: Palette.error,
        icon: Icons.do_not_disturb_on_outlined,
        tooltipError: null,
        onPressed: onTap,
      ),
    );
  }
}
