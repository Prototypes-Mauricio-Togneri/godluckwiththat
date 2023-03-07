import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:tensionnode/components/base/drone_manager.dart';
import 'package:tensionnode/components/game/moving_drone.dart';
import 'package:tensionnode/extensions/sprite_component_extension.dart';
import 'package:tensionnode/game/game_component.dart';
import 'package:tensionnode/models/drone.dart';
import 'package:tensionnode/models/inventory.dart';
import 'package:tensionnode/models/location.dart';
import 'package:tensionnode/types/node_type.dart';
import 'package:tensionnode/utils/palette.dart';
import 'package:tensionnode/utils/style.dart';

class Node extends SpriteComponent
    with HasGameRef<GameComponent>, Tappable, NodeManager {
  final NodeType type;
  final Location location;
  final Inventory inventory;

  late final DebugText debugText = DebugText();

  Node({
    required this.type,
    required this.location,
    required this.inventory,
    required List<Drone> drones,
    required List<Node> droneConnections,
    required List<Node> droneTransfers,
  }) {
    initialize(
      drones: drones,
      droneConnections: droneConnections,
      droneTransfers: droneTransfers,
    );
  }

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
    if (movingDrone.hasWaypoints) {
      receiveDrone(movingDrone.drone);
    } else {
      addDrone(movingDrone.drone);
    }

    updateMenu();
  }

  void receiveDrone(Drone drone) {}

  void sendDrone({
    required Drone drone,
    required List<Node> waypoints,
  }) {
    final MovingDrone movingDrone = MovingDrone(
      drone: drone,
      nodeOrigin: this,
      waypoints: waypoints,
    );
    game.addComponent(movingDrone);
    updateMenu();
  }

  void evacuateDrones(Node node) {
    for (int i = 0; i < availableDrones; i++) {
      sendDrone(
        drone: Drone(),
        waypoints: [node],
      );
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (hasDroneTransfers) {
      for (final Node to in droneTransfers) {
        final bool sent = _checkTransferDrone(to);

        if (sent) {
          removeDroneTransfer(to);
        }
      }
    }
  }

  void transferDroneTo(Node to) {
    final bool sent = _checkTransferDrone(to);

    if (!sent) {
      addDroneTransfer(to);
    }
  }

  Drone? getAvailableDrone() {
    if (hasDrones) {
      return getDrone();
    } else {
      return null;
    }
  }

  bool _checkTransferDrone(Node to) {
    final Drone? drone = getAvailableDrone();

    if (drone != null) {
      sendDrone(
        drone: drone,
        waypoints: [to],
      );
      return true;
    } else {
      return false;
    }
  }

  bool isAt(Location location) => this.location == location;

  double distanceTo(Node node) => location.distanceTo(node.location);

  @override
  bool onTapUp(TapUpInfo info) {
    game.selectNode(this);
    game.clickHandled = true;

    return true;
  }

  void destroy(bool sendDronesBack) {
    game.removeNode(
      node: this,
      sendDronesBack: sendDronesBack,
    );
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
