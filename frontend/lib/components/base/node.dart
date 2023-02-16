import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:tensionnode/extensions/sprite_component_extension.dart';
import 'package:tensionnode/game/game_component.dart';
import 'package:tensionnode/models/location.dart';
import 'package:tensionnode/models/road.dart';
import 'package:tensionnode/types/node_type.dart';
import 'package:tensionnode/types/resource_type.dart';

class Node extends SpriteComponent with HasGameRef<GameComponent>, Tappable {
  final Location location;
  final NodeType type;
  Road? roadNorth;
  Road? roadEast;
  Road? roadSouth;
  Road? roadWest;

  Node({
    required this.type,
    required this.location,
    this.roadNorth,
    this.roadEast,
    this.roadSouth,
    this.roadWest,
  });

  @override
  Future onLoad() async {
    sprite = await getSprite(type.sprite);
    size = getSize();
    anchor = Anchor.center;
    position = location.position;

    return super.onLoad();
  }

  void connect({
    Road? north,
    Road? east,
    Road? south,
    Road? west,
  }) {
    roadNorth = north;
    roadEast = east;
    roadSouth = south;
    roadWest = west;
  }

  void receive(ResourceType resource) {}

  Road? get availableRoad {
    if ((roadNorth != null) && (roadNorth!.isAvailable)) {
      return roadNorth;
    } else if ((roadEast != null) && (roadEast!.isAvailable)) {
      return roadEast;
    } else if ((roadSouth != null) && (roadSouth!.isAvailable)) {
      return roadSouth;
    } else if ((roadWest != null) && (roadWest!.isAvailable)) {
      return roadWest;
    } else {
      return null;
    }
  }

  bool isAt(Location location) => this.location == location;

  @override
  bool onTapUp(TapUpInfo info) => false;

  @override
  bool onTapDown(TapDownInfo info) => false;

  void destroy() {
    game.removeNode(this);
  }

  @override
  void update(double dt) {
    super.update(dt);

    roadNorth?.update(dt);
    roadEast?.update(dt);
    roadSouth?.update(dt);
    roadWest?.update(dt);
  }
}
