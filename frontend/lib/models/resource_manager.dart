import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/models/route.dart';
import 'package:tensionnode/models/routed_resource.dart';
import 'package:tensionnode/services/graph.dart';
import 'package:tensionnode/types/resource_type.dart';

class ResourceManager {
  final Graph graph = Graph();
  final Map<ResourceType, List<ResourceRequest>> _requests = {};
  final List<Node> _warehouses = [];

  List<ResourceRequest> requestsFor(ResourceType resource) =>
      _requests[resource] ?? [];

  void addWarehouse(Node node) {
    _warehouses.add(node);
  }

  void addRequest(ResourceRequest request) {
    final List<ResourceRequest> requests = requestsFor(request.resource);
    requests.add(request);

    _requests[request.resource] = requests;
  }

  void removeRequest(ResourceRequest request) {
    _requests.remove(request);
  }

  RoutedResource? query({
    required Node origin,
    required ResourceType resource,
    // TODO(momo): required Route route, // TODO(momo): remove parameter
  }) {
    // TODO(momo): sort by resource, order by priority and select the closest
    // TODO(momo): check that the resource can be routed from the origin to the target

    ResourceRequest? result;
    Route? calculatedRoute;
    final List<ResourceRequest> requests = requestsFor(resource);

    for (final ResourceRequest request in requests) {
      if (request.resource == resource) {
        result = request;
        calculatedRoute = graph.search(origin, request.requester);

        if (calculatedRoute != null) {
          break;
        }
      }
    }

    if ((result != null) && (calculatedRoute != null)) {
      _requests[resource]?.remove(result);

      return RoutedResource(
        route: calculatedRoute,
        resource: resource,
      );
    } else if (_warehouses.isNotEmpty) {
      //_warehouses.sort((a, b) => a.location.distanceTo(origin.location));
      // TODO(momo): get closest warehouse and calculate route
      calculatedRoute = graph.search(origin, _warehouses[0]);

      if (calculatedRoute != null) {
        return RoutedResource(
          route: calculatedRoute,
          resource: resource,
        );
      }
    }

    return null;
  }

  @override
  String toString() => _requests.toString();
}

class ResourceRequest {
  final Node requester;
  final ResourceType resource;
  final double priority;

  const ResourceRequest({
    required this.requester,
    required this.resource,
    required this.priority,
  });

  @override
  String toString() => '${requester.runtimeType}';
}
