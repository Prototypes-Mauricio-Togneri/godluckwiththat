import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/models/route.dart';
import 'package:tensionnode/services/json.dart';
import 'package:tensionnode/types/resource_type.dart';

class RoutedResource {
  final Route route;
  final ResourceType resource;

  const RoutedResource({
    required this.route,
    required this.resource,
  });

  bool isDestination(Node node) => route.isDestination(node);

  bool has(ResourceType resource) => this.resource == resource;

  void pop() => route.pop();

  @override
  String toString() => Json.encode({
        'route': route.toString(),
        'resource': resource.name,
      });
}
