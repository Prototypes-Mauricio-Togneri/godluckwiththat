import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:gatewayguardians/game/game_state.dart';
import 'package:gatewayguardians/models/buildings/building.dart';
import 'package:gatewayguardians/models/zone.dart';
import 'package:gatewayguardians/utils/palette.dart';
import 'package:gatewayguardians/widgets/label.dart';

class BuildingHud extends StatelessWidget {
  final GameState state;
  final Zone zone;
  final Building building;

  const BuildingHud({
    required this.state,
    required this.zone,
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
          if (building.isTrainer)
            TrainerBlock(
              state: state,
              zone: zone,
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
              '${building.resourcesPerTurn} ${building.buildingType.produces.toString()}/turn',
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
              onTap: state.colony.hasFreeVillagers
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
  final Zone zone;

  const TrainerBlock({
    required this.state,
    required this.zone,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const VBox(20),
        const Label(
          text: 'TRAIN VILLAGERS:',
          size: 14,
          color: Palette.white,
        ),
        const VBox(20),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            VillagerButton(
              color: Palette.error,
              onTap: zone.hasActionTrain
                  ? () => state.untrainVillager(zone)
                  : null,
              icon: Icons.remove,
            ),
            const HBox(20),
            Label(
              text: zone.hasActionTrain ? '${zone.action!.villagers}' : '0',
              size: 20,
              color: Palette.white,
            ),
            const HBox(20),
            VillagerButton(
              color: Palette.success,
              onTap: state.colony.hasResource(zone.trainVillagerCost)
                  ? () => state.trainVillager(zone)
                  : null,
              icon: Icons.add,
            ),
          ],
        ),
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
