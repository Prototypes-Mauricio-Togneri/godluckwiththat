import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:tensionnode/components/base/building.dart';
import 'package:tensionnode/components/game/construction.dart';
import 'package:tensionnode/components/game/headquarters.dart';
import 'package:tensionnode/extensions/sprite_component_extension.dart';
import 'package:tensionnode/game/game_component.dart';
import 'package:tensionnode/models/connection.dart';
import 'package:tensionnode/models/inventory.dart';
import 'package:tensionnode/models/location.dart';
import 'package:tensionnode/models/resource.dart';
import 'package:tensionnode/types/node_type.dart';
import 'package:tensionnode/types/resource_type.dart';
import 'package:tensionnode/utils/palette.dart';
import 'package:tensionnode/utils/style.dart';

class Node extends SpriteComponent with HasGameRef<GameComponent>, Tappable {
  final NodeType type;
  final Location location;
  final Inventory inventory;
  final List<Connection> connections;
  int _connectionIndex = 0;

  late final DebugText debugText = DebugText();
  late final DroneCounter droneCounter = DroneCounter();
  late final EfficiencyText efficiencyText = EfficiencyText();

  Node({
    required this.type,
    required this.location,
    required this.inventory,
    required this.connections,
  });

  bool get isBuildingOrHeadquarters =>
      (this is Building) || (this is Headquarters);

  int get freeDrones => inventory.get(ResourceType.drone);

  bool get hasDrones => freeDrones > 0;

  int get totalDrones => freeDrones + connections.length;

  bool get hasConnections => connections.isNotEmpty;

  Connection get getAvailableConnection {
    _connectionIndex++;
    final int index = _connectionIndex % connections.length;

    return connections[index];
  }

  @override
  Future onLoad() async {
    sprite = await getSprite(type.sprite);
    size = getSize();
    anchor = Anchor.center;
    position = location.position;

    add(debugText);
    add(droneCounter);
    add(efficiencyText);

    return super.onLoad();
  }

  void updateMenu() {
    if (game.isNodeSelected(this)) {
      game.state.notify();
    }
  }

  void receiveResource(Resource resource) {
    inventory.addResource(resource);
    updateMenu();
  }

  void transferDroneTo(Node node) {
    if (hasDrones) {
      final Resource resource = Resource.one(ResourceType.drone);
      inventory.removeResource(resource);
      node.inventory.addResource(resource);
    }
    updateMenu();
  }

  Connection? getConnection(Node to) {
    for (final Connection connection in connections) {
      if (connection.to == to) {
        return connection;
      }
    }

    return null;
  }

  bool hasConnection(Node to) => getConnection(to) != null;

  void addDroneConnection(Node to) {
    if (hasDrones && !hasConnection(to)) {
      final Resource resource = Resource.one(ResourceType.drone);
      inventory.removeResource(resource);
      connections.add(Connection(to));
    }
  }

  void removeDroneConnection(Node to) {
    final Connection? connection = getConnection(to);

    if (connection != null) {
      connections.remove(connection);
      final Resource resource = Resource.one(ResourceType.drone);
      inventory.addResource(resource);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!(this is Construction)) {
      final int amountOfDrones = freeDrones;
      droneCounter.text = (amountOfDrones > 0) ? '$amountOfDrones' : '';
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

class DroneCounter extends TextComponent {
  late Node node;

  @override
  FutureOr onLoad() {
    node = parent as Node;
    position = node.size;
    anchor = Anchor.center;
    textRenderer = Style.debugTextRenderer(
      size: 2,
      color: Palette.error,
    );

    return super.onLoad();
  }
}

class EfficiencyText extends TextComponent {
  late Node node;

  @override
  FutureOr onLoad() {
    node = parent as Node;
    position = Vector2(0, node.size.y);
    anchor = Anchor.center;
    textRenderer = Style.debugTextRenderer(
      size: 2,
      color: Palette.error,
    );

    return super.onLoad();
  }
}
