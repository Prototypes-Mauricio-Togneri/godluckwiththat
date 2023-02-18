import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/models/route.dart';
import 'package:tensionnode/models/routed_resource.dart';
import 'package:tensionnode/types/resource_type.dart';

class ResourceManager {
  final List<ResourceRequest> _requests = [];

  void addRequest(ResourceRequest request) {
    _requests.add(request);
  }

  void removeRequest(ResourceRequest request) {
    _requests.remove(request);
  }

  RoutedResource? query({
    required Node origin,
    required ResourceType resource,
    required Route route, // TODO(momo): remove parameter
  }) {
    // TODO(momo): sort by resource, order by priority and select the closest
    // TODO(momo): check that the resource can be routed from the origin to the target

    ResourceRequest? result;

    for (final ResourceRequest request in _requests) {
      if (request.resource == resource) {
        result = request;
        break;
      }
    }

    if (result != null) {
      _requests.remove(result);

      return RoutedResource(
        route: route,
        resource: resource,
      );
    } else {
      return null;
    }
  }
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
}
