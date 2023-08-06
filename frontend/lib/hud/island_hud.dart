import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:gatewayguardians/game/game_state.dart';
import 'package:gatewayguardians/models/island.dart';
import 'package:gatewayguardians/utils/palette.dart';
import 'package:gatewayguardians/widgets/cancel_button.dart';
import 'package:gatewayguardians/widgets/label.dart';
import 'package:gatewayguardians/widgets/primary_button.dart';

class IslandHud extends StatelessWidget {
  final GameState state;
  final Island island;

  const IslandHud({
    required this.state,
    required this.island,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      width: double.infinity,
      color: Palette.blackOverlay,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const VBox(20),
          Label(
            text: 'Island: ${island.id}',
            size: 16,
            color: Palette.white,
          ),
          /*if (island.isExplored)
            IslandExplored(
              state: state,
              island: island,
            )
          else if (island.isUnexplored)
            IslandUnexplored(
              state: state,
              island: island,
            ),*/
          const VBox(20),
        ],
      ),
    );
  }
}

class IslandExplored extends StatelessWidget {
  final GameState state;
  final Island island;

  const IslandExplored({
    required this.state,
    required this.island,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /*if (island.hasPatch) ...[
          const VBox(20),
          Label(
            text: island.tiles
                .where((e) => e.patchType != null)
                .map((e) => e.patchType)
                .join(','),
            size: 16,
            color: Palette.white,
          ),
        ],*/
        if (island.isNeutral)
          IslandNeutral(
            state: state,
            island: island,
          )
        else
          IslandOwned(
            state: state,
            island: island,
          ),
      ],
    );
  }
}

class IslandUnexplored extends StatelessWidget {
  final GameState state;
  final Island island;

  const IslandUnexplored({
    required this.state,
    required this.island,
  });

  @override
  Widget build(BuildContext context) {
    if (island.hasAction) {
      return CancelButton(
        state: state,
        island: island,
        action: island.actions.first,
      );
    } /*else if (island.canBeExplored(state)) {
      return Padding(
        padding: const EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
        ),
        child: PrimaryButton(
          text: 'EXPLORE',
          color: Palette.success,
          icon: Icons.explore_outlined,
          tooltipError: island.explorationCost.join(),
          onPressed: state.colony.hasFreeVillagers &&
                  state.colony.hasResources(island.explorationCost)
              ? () => state.explore(island)
              : null,
        ),
      );
    } */
    else {
      return const Empty();
    }
  }
}

class IslandNeutral extends StatelessWidget {
  final GameState state;
  final Island island;

  const IslandNeutral({
    required this.state,
    required this.island,
  });

  @override
  Widget build(BuildContext context) {
    if (island.hasAction) {
      return CancelButton(
        state: state,
        island: island,
        action: island.actions.first,
      );
    } /*else if (island.canBeClaimed(state)) {
      return Padding(
        padding: const EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
        ),
        child: PrimaryButton(
          text: 'CLAIM',
          color: Palette.success,
          icon: Icons.flag,
          tooltipError: island.claimCost.join(),
          onPressed: state.colony.hasResources(island.claimCost)
              ? () => state.claim(island)
              : null,
        ),
      );
    } */
    else {
      return const Empty();
    }
  }
}

class IslandOwned extends StatelessWidget {
  final GameState state;
  final Island island;

  const IslandOwned({
    required this.state,
    required this.island,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (island.hasAction)
          CancelButton(
            state: state,
            island: island,
            action: island.actions.first,
          )
        else
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
            ),
            child: PrimaryButton(
              text: 'BUILD',
              color: Palette.success,
              icon: Icons.construction,
              tooltipError: 'NO FREE VILLAGERS AVAILABLE',
              onPressed: state.colony.hasFreeVillagers
                  ? () => state.onBuild(island)
                  : null,
            ),
          ),
        /*for (Tile tile in island.tiles)
          if (tile.building != null)
            BuildingHud(
              state: state,
              island: island,
              building: tile.building!,
            ),*/
      ],
    );
  }
}
