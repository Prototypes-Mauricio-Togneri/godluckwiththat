import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:tensionnode/components/game/moving_drone.dart';
import 'package:tensionnode/extensions/sprite_component_extension.dart';
import 'package:tensionnode/game/game_component.dart';
import 'package:tensionnode/models/drone.dart';
import 'package:tensionnode/models/location.dart';
import 'package:tensionnode/services/palette.dart';
import 'package:tensionnode/services/style.dart';
import 'package:tensionnode/types/node_type.dart';

class Node extends SpriteComponent with HasGameRef<GameComponent>, Tappable {
  final NodeType type;
  final Location location;
  final List<Drone> constructionDrones;
  final List<Drone> logisticDrones;

  late final DebugText debugText = DebugText();

  Node({
    required this.type,
    required this.location,
    required this.constructionDrones,
    required this.logisticDrones,
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

  void updateMenu() {
    if (game.isNodeSelected(this)) {
      game.state.notify();
    }
  }

  void receiveMovingDrone(MovingDrone movingDrone) {
    receiveDone(movingDrone.drone);
    updateMenu();
  }

  void receiveDone(Drone drone) {}

  void sendDrone({
    required Drone drone,
    required List<Node> waypoints,
  }) {
    final MovingDrone movingDrone = MovingDrone(
      drone: drone,
      origin: this,
      waypoints: waypoints,
    );
    add(movingDrone);
    updateMenu();
  }

  bool isAt(Location location) => this.location == location;

  double distanceTo(Node node) => location.distanceTo(node.location);

  @override
  bool onTapUp(TapUpInfo info) {
    game.selectNode(this);

    return true;
  }

  @override
  bool onTapDown(TapDownInfo info) => false;

  void destroy() {
    game.removeNode(this);
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
