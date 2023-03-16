import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:tensionplanet/components/base/building.dart';
import 'package:tensionplanet/components/game/buildings/factories/drone_factory.dart';
import 'package:tensionplanet/components/game/construction.dart';
import 'package:tensionplanet/components/game/headquarters.dart';
import 'package:tensionplanet/components/game/signs/stopped_sign.dart';
import 'package:tensionplanet/components/game/warehouse.dart';
import 'package:tensionplanet/extensions/sprite_component_extension.dart';
import 'package:tensionplanet/game/game_component.dart';
import 'package:tensionplanet/models/connection.dart';
import 'package:tensionplanet/models/inventory.dart';
import 'package:tensionplanet/models/location.dart';
import 'package:tensionplanet/models/resource.dart';
import 'package:tensionplanet/types/node_type.dart';
import 'package:tensionplanet/types/resource_type.dart';
import 'package:tensionplanet/utils/palette.dart';
import 'package:tensionplanet/utils/style.dart';
import 'package:tensionplanet/utils/toast.dart';

class Node extends SpriteComponent with HasGameRef<GameComponent>, Tappable {
  final NodeType nodeType;
  final Location location;
  final Inventory inventory;
  final List<Connection> connections;
  bool enabled = true;
  int connectionIndex = 0;
  StoppedSign? stoppedSign;

  late final DebugText debugText = DebugText();
  late final DroneCounter droneCounter = DroneCounter();
  late final EfficiencyText efficiencyText = EfficiencyText();

  Node({
    required this.nodeType,
    required this.location,
    required this.inventory,
    required this.connections,
  });

  bool get isConstruction => this is Construction;

  bool get isBuilding => this is Building;

  bool get isHeadquarters => this is Headquarters;

  bool get isWarehouse => this is Warehouse;

  bool get isDroneFactory => this is DroneFactory;

  bool get isBuildingOrHeadquartersOrWareHouse =>
      isBuilding || isHeadquarters || isWarehouse;

  int get freeDrones => inventory.get(ResourceType.drone);

  bool get hasDrones => freeDrones > 0; // TODO(momo): used?

  int get totalDrones => freeDrones + connections.length;

  bool get hasConnections => connections.isNotEmpty;

  List<Connection> get busyConnections =>
      connections.where((e) => !e.isAvailable).toList();

  Connection? get nextAvailableConnection {
    connectionIndex++;
    final int index = connectionIndex % connections.length;
    final Connection connection = connections[index];

    return connection.isAvailable ? connection : null;
  }

  @override
  Future onLoad() async {
    sprite = await getSprite(nodeType.sprite);
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
    final Connection connection = Connection.empty(
      from: this,
      to: to,
      research: game.state.research,
    );

    if (game.state.headquarters.hasDrones) {
      final Resource resource = Resource.one(ResourceType.drone);
      game.state.headquarters.inventory.removeResource(resource);
      connections.add(connection);
      updateMenu();
    } else {
      Toast.show('No drones available to make a connection');
    }
  }

  void removeDroneConnection(Node to) {
    final Connection? connection = getConnection(to);

    if (connection != null) {
      final Resource resource = Resource.one(ResourceType.drone);
      game.state.headquarters.inventory.addResource(resource);
      connections.remove(connection);
      updateMenu();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!isConstruction) {
      final int amountOfDrones = freeDrones;
      droneCounter.text = (amountOfDrones > 0) ? '$amountOfDrones' : '';
    }

    for (final Connection connection in busyConnections) {
      connection.update(dt);
    }

    if (!enabled) {
      _showStoppedSign();
    } else {
      _hideStoppedSign();
    }
  }

  bool isAt(Location location) => this.location == location;

  double distanceTo(Node node) => location.distanceTo(node.location);

  ResourceType get outputType {
    if (this is Building) {
      return (this as Building).resourceProduced;
    } else if (this is Warehouse) {
      return (this as Warehouse).resourceType;
    } else {
      throw Exception('Node cannot produce any resource');
    }
  }

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

  void _showStoppedSign() {
    if (stoppedSign == null) {
      stoppedSign = StoppedSign();
      add(stoppedSign!);
    }
  }

  void _hideStoppedSign() {
    if (stoppedSign != null) {
      remove(stoppedSign!);
      stoppedSign = null;
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
