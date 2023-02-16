import 'package:tensionnode/components/base/node.dart';

class Road {
  final Node origin;
  final Node target;
  final num distance;

  Road(this.origin, this.target)
      : distance = origin.location.distanceTo(target.location);

  void update(double dt) {}
}
