import 'package:tensionplanet/components/base/node.dart';
import 'package:tensionplanet/models/resource.dart';
import 'package:tensionplanet/types/connection_state.dart';

class Connection {
  final Node to;
  ConnectionState state;
  Resource? resource;
  double progress;

  Connection({
    required this.to,
    required this.state,
    required this.resource,
    required this.progress,
  });

  factory Connection.empty(Node to) => Connection(
        to: to,
        state: ConnectionState.available,
        resource: null,
        progress: 0,
      );
}
