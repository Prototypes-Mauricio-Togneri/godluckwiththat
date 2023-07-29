import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:gatewayguardians/game/game_state.dart';
import 'package:gatewayguardians/models/action.dart';
import 'package:gatewayguardians/models/buildings/building.dart';
import 'package:gatewayguardians/models/buildings/producer.dart';
import 'package:gatewayguardians/models/zone.dart';
import 'package:gatewayguardians/utils/palette.dart';
import 'package:gatewayguardians/widgets/cancel_button.dart';
import 'package:gatewayguardians/widgets/label.dart';
import 'package:gatewayguardians/widgets/primary_button.dart';

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
          if (zone.hasActionDestroy || zone.hasActionLevelUp)
            CancelButton(
              state: state,
              zone: zone,
              action: zone.actions.first,
            ),
          if (!zone.hasAction)
            Padding(
              padding: const EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
              ),
              child: PrimaryButton(
                text: 'LEVEL UP',
                color: Palette.success,
                icon: Icons.arrow_circle_up_outlined,
                onPressed: state.colony.inventory.has(building.costNextLevel)
                    ? () => state.levelUp(
                          zone: zone,
                          building: building,
                        )
                    : null,
              ),
            ),
          if (!zone.hasAction && building.isDestroyable)
            Padding(
              padding: const EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
              ),
              child: PrimaryButton(
                text: 'DESTROY',
                color: Palette.error,
                icon: Icons.delete_forever,
                onPressed: state.colony.hasFreeVillagers
                    ? () => state.destroy(
                          zone: zone,
                          building: building,
                        )
                    : null,
              ),
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
              '${(building as Producer).resourcesPerTurn} ${building.buildingType.produces.toString()}/turn',
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
        Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
          ),
          child: PrimaryButton(
            text: 'CREATE VILLAGER',
            color: Palette.success,
            icon: Icons.person,
            onPressed: state.colony.hasResource(zone.trainVillagerCost)
                ? () => state.trainVillager(zone)
                : null,
          ),
        ),
        for (final Action action in zone.actions)
          QueuedAction(
            text: 'CREATE VILLAGER',
            onTap: () => state.cancel(
              zone: zone,
              action: action,
            ),
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
        onPressed: onTap,
      ),
    );
  }
}
