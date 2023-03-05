import 'package:tensionnode/models/resource.dart';

class Drone {
  Resource? _resource;

  Drone();

  bool get hasResource => _resource != null;

  void load(Resource resource) {
    _resource = resource;
  }

  Resource? unload() {
    final Resource? result = _resource;
    _resource = null;

    return result;
  }
}
