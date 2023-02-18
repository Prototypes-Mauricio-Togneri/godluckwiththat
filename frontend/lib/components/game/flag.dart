import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/json/json_flag.dart';
import 'package:tensionnode/models/routed_resource.dart';

class Flag extends Node {
  final List<RoutedResource> queue = [];

  Flag({
    required super.type,
    required super.location,
  });

  @override
  void receive(RoutedResource routedResource) {
    if (routedResource.isDestination(this)) {
      throw Exception(
          'Routed resource $routedResource arrived to flag $this as destination');
    } else {
      routedResource.pop();
      queue.add(routedResource);
    }
  }

  void _sendResources() {
    final List<RoutedResource> removeFromQueue = [];

    for (final RoutedResource routedResource in queue) {
      final bool sent = send(routedResource);

      if (sent) {
        removeFromQueue.add(routedResource);
      }
    }

    for (final RoutedResource routedResource in removeFromQueue) {
      queue.remove(routedResource);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    _sendResources();
    debugText.text = queue.toString();
  }

  JsonFlag get json => JsonFlag(
        location: location.json,
        connections: roads.json,
      );
}
