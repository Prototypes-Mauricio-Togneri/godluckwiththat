import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:tensionnode/extensions/sprite_component_extension.dart';
import 'package:tensionnode/game/game_component.dart';
import 'package:tensionnode/models/location.dart';
import 'package:tensionnode/models/road.dart';
import 'package:tensionnode/models/roads.dart';
import 'package:tensionnode/models/routed_resource.dart';
import 'package:tensionnode/services/palette.dart';
import 'package:tensionnode/services/style.dart';
import 'package:tensionnode/types/node_type.dart';
import 'package:tensionnode/types/resource_type.dart';

class Node extends SpriteComponent with HasGameRef<GameComponent>, Tappable {
  final Location location;
  final NodeType type;
  final Roads roads = Roads();

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

  void connect(Roads roads) {
    this.roads.connect(roads);
  }

  void receive(ResourceType resource) {}

  Road? get availableRoad {
    if ((roads.south != null) && (roads.south!.isAvailable)) {
      return roads.south;
    } else if ((roads.west != null) && (roads.west!.isAvailable)) {
      return roads.west;
    } else if ((roads.north != null) && (roads.north!.isAvailable)) {
      return roads.north;
    } else if ((roads.east != null) && (roads.east!.isAvailable)) {
      return roads.east;
    } else {
      return null;
    }
  }

  bool send(RoutedResource? routedResource) {
    bool sent = false;

    if (routedResource != null) {
      final Road? road = availableRoad;

      if (road != null) {
        road.send(_resource!);
        _resource = null;
        sent = true;
      }
    }

    return sent;
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

    roads.north?.update(dt);
    roads.east?.update(dt);
    roads.south?.update(dt);
    roads.west?.update(dt);
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
