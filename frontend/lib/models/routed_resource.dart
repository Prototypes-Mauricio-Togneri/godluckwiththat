import 'package:tensionnode/models/route.dart';
import 'package:tensionnode/types/resource_type.dart';

class RoutedResource {
  final Route route;
  final ResourceType resource;

  const RoutedResource({
    required this.route,
    required this.resource,
  });
}
