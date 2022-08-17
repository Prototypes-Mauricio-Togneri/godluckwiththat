import 'package:tensionnode/engine/renderer.dart';
import 'package:tensionnode/model/connection.dart';
import 'package:tensionnode/model/nodes/node.dart';

class Connections {
  final List<Connection> _connections = [];

  void add(Node? from, Node? to) {
    if ((from != null) && (to != null)) {
      _add(
        Connection(
          from: from,
          to: to,
        ),
      );
    }
  }

  Connection _add(Connection element) {
    _connections.add(element);

    return element;
  }

  void update(double dt) {
    for (final Connection connection in _connections) {
      connection.update(dt);
    }
  }

  void render(Renderer renderer) {
    for (final Connection connection in _connections) {
      connection.render(renderer);
    }
  }
}
