import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/models/resource.dart';

class Drone {
  final Node home;
  Resource? _resource;

  Drone(this.home);

  bool get hasResource => _resource != null;

  bool isHome(Node node) => home == node;

  void load(Resource resource) {
    _resource = resource;
  }

  Resource? unload() {
    final Resource? result = _resource;
    _resource = null;

    return result;
  }
}
