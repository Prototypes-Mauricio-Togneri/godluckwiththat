import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/types/resource_type.dart';

class ResourceManager {
  final List<ResourceRequest> requests = [];

  void addRequest(ResourceRequest request) {
    requests.add(request);
  }

  void removeRequest(ResourceRequest request) {
    requests.remove(request);
  }

  ResourceRequest? query(ResourceType resource) {
    for (final ResourceRequest request in requests) {
      if (request.resource == resource) {
        return request;
      }
    }

    return null;
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
