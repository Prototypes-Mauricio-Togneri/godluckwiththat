import 'package:flame/components.dart';
import 'package:tensionplanet/app/constants.dart';
import 'package:tensionplanet/components/base/node.dart';
import 'package:tensionplanet/models/research.dart';
import 'package:tensionplanet/models/resource.dart';
import 'package:tensionplanet/types/connection_state.dart';

class Connection {
  final Node from;
  final Node to;
  final Research research;
  late final Vector2 direction;
  late final double distance;
  ConnectionState state;
  Resource? resource;
  double progress;

  Connection({
    required this.from,
    required this.to,
    required this.research,
    required this.state,
    required this.resource,
    required this.progress,
  }) {
    direction = to.position - from.position;
    distance = direction.length / Constants.NODE_SIZE;
  }

  bool get isAvailable => state == ConnectionState.available;

  Vector2 get position => direction * progress;

  void send(Resource newResource) {
    state = ConnectionState.sending;
    resource = newResource;
    progress = 0;
  }

  void update(double dt) {
    final double moved = (dt / distance) * research.droneSpeed;

    if (state == ConnectionState.sending) {
      progress += moved;

      if (progress >= 1) {
        progress = 1;
        state = ConnectionState.returning;
        to.receiveResource(resource!);
        resource = null;
      }
    } else if (state == ConnectionState.returning) {
      progress -= moved;

      if (progress <= 0) {
        progress = 0;
        state = ConnectionState.available;
      }
    }
  }

  factory Connection.empty({
    required Node from,
    required Node to,
    required Research research,
  }) =>
      Connection(
        from: from,
        to: to,
        research: research,
        state: ConnectionState.available,
        resource: null,
        progress: 0,
      );
}
