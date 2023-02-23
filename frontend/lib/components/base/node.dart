import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:tensionnode/extensions/sprite_component_extension.dart';
import 'package:tensionnode/game/game_component.dart';
import 'package:tensionnode/models/location.dart';
import 'package:tensionnode/models/road.dart';
import 'package:tensionnode/models/routed_resource.dart';
import 'package:tensionnode/services/palette.dart';
import 'package:tensionnode/services/style.dart';
import 'package:tensionnode/types/node_type.dart';

class Node extends SpriteComponent with HasGameRef<GameComponent>, Tappable {
  final NodeType type;
  final Location location;
  final Roads roads = [];

  late final DebugText debugText = DebugText();

  Node({
    required this.type,
    required this.location,
  });

  @override
  Future onLoad() async {
    sprite = await getSprite(type.sprite);
    size = getSize();
    anchor = Anchor.center;
    position = location.position;

    add(debugText);

    return super.onLoad();
  }

  void addRoad(Road road) {
    roads.add(road);
  }

  void receiveResource(RoutedResource routedResource) {
    receive(routedResource);

    if (game.isNodeSelected(this)) {
      game.state.notify();
    }
  }

  void receive(RoutedResource routedResource) {}

  Road? _roadTo(Location? location) {
    if (location != null) {
      for (final Road road in roads) {
        if (road.target.location == location) {
          return road;
        }
      }
    }

    return null;
  }

  double distanceTo(Node node) => location.distanceTo(node.location);

  bool send(RoutedResource? routedResource) {
    bool sent = false;

    if (routedResource != null) {
      final Road? road = _roadTo(routedResource.route.first);

      if ((road != null) && (road.isAvailable)) {
        road.send(routedResource);
        game.state.notify();
        sent = true;
      }
    }

    return sent;
  }

  void removeRequest(RoutedResource? routedResource) {
    if (routedResource != null) {
      game.state.resourceManager.removeRequest(routedResource.request);
    }
  }

  bool isAt(Location location) => this.location == location;

  @override
  bool onTapUp(TapUpInfo info) => game.selectNode(this);

  @override
  bool onTapDown(TapDownInfo info) => false;

  void destroy() {
    game.removeNode(this);
  }

  @override
  void update(double dt) {
    super.update(dt);

    for (final Road road in roads) {
      road.update(dt);
    }
  }
}

class DebugText extends TextComponent {
  late Node node;

  @override
  FutureOr onLoad() {
    node = parent as Node;
    position = node.size / 2;
    anchor = Anchor.center;
    textRenderer = Style.debugTextRenderer(
      size: 2,
      color: Palette.error,
    );

    return super.onLoad();
  }
}
