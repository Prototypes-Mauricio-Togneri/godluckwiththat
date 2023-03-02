import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/components/game/moving_drone.dart';
import 'package:tensionnode/json/json_building.dart';
import 'package:tensionnode/models/resource.dart';
import 'package:tensionnode/types/resource_type.dart';

class Construction extends Node {
  int remainingIronBlock = 0;
  int remainingCopperBlock = 0;
  int remainingSteel = 0;
  int remainingConcrete = 0;

  Construction({
    required super.type,
    required super.location,
  });

  @override
  Future onLoad() {
    opacity = 0.5;

    remainingIronBlock = type.iron;
    remainingCopperBlock = type.copper;
    remainingSteel = type.steel;
    remainingConcrete = type.concrete;

    return super.onLoad();
  }

  @override
  void receive(MovingDrone movingDrone) {
    final Resource resource = movingDrone.resource;

    if (resource.type == ResourceType.iron_block) {
      remainingIronBlock -= resource.amount;
    } else if (resource.type == ResourceType.copper_block) {
      remainingCopperBlock -= resource.amount;
    } else if (resource.type == ResourceType.steel) {
      remainingSteel -= resource.amount;
    } else if (resource.type == ResourceType.concrete) {
      remainingConcrete -= resource.amount;
    }

    if ((remainingIronBlock <= 0) &&
        (remainingCopperBlock <= 0) &&
        (remainingSteel <= 0) &&
        (remainingConcrete <= 0)) {
      destroy();
      game.buildNode(
        location: location,
        type: type,
      );
    }
  }

  JsonBuilding get json => JsonBuilding(
        location: location.json,
      );
}
