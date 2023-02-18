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

  bool get isDestination => route.isEmpty;

  bool has(ResourceType resource) => this.resource == resource;

  void pop() => route.pop();

  @override
  String toString() => Json.encode({
        route: route.toString(),
        resource: resource,
      });
}
