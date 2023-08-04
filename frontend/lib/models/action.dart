import 'package:gatewayguardians/extensions/resource_map_extension.dart';
import 'package:gatewayguardians/models/buildings/building.dart';
import 'package:gatewayguardians/models/tile.dart';
import 'package:gatewayguardians/types/action_type.dart';
import 'package:gatewayguardians/types/building_type.dart';

class Action {
  final ActionType actionType;
  final int villagers;
  final Tile? tile;
  final Building? building;
  final ResourceMap? cost;
  int turns;

  Action._({
    required this.actionType,
    required this.villagers,
    required this.turns,
    required this.tile,
    required this.building,
    required this.cost,
  });

  bool passTurn() {
    turns--;

    return turns == 0;
  }

  factory Action.explore() => Action._(
        actionType: ActionType.explore,
        villagers: 1,
        turns: 1,
        tile: null,
        building: null,
        cost: null,
      );

  factory Action.claim() => Action._(
        actionType: ActionType.claim,
        villagers: 1,
        turns: 1,
        tile: null,
        building: null,
        cost: null,
      );

  factory Action.build({
    required Tile tile,
    required BuildingType buildingType,
    required ResourceMap cost,
  }) =>
      Action._(
        actionType: ActionType.build,
        villagers: 1,
        turns: 1,
        tile: tile,
        building: Building.create(
          buildingType: buildingType,
          level: 1,
          villagers: 0,
        ),
        cost: cost,
      );

  factory Action.levelUp({
    required Tile tile,
    required ResourceMap cost,
  }) =>
      Action._(
        actionType: ActionType.levelUp,
        villagers: 0,
        turns: 1,
        tile: tile,
        building: null,
        cost: cost,
      );

  factory Action.train(int amount) => Action._(
        actionType: ActionType.train,
        villagers: amount,
        turns: 1,
        tile: null,
        building: null,
        cost: null,
      );

  factory Action.destroy(Tile tile) => Action._(
        actionType: ActionType.destroy,
        villagers: 1,
        turns: 1,
        tile: tile,
        building: null,
        cost: null,
      );
}
