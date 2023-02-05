import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:tensionnode/components/base/fixed_node.dart';
import 'package:tensionnode/components/base/node.dart';

mixin ComponentHandler on FlameGame {
  void removeComponents(Type type) => removeWhere((c) {
        c.removeWhere((c) => c.runtimeType == type);

        return c.runtimeType == type;
      });

  bool hasComponent(Type type) => children.any((c) => c.runtimeType == type);

  T getComponent<T extends Component>(Type type) =>
      children.singleWhere((c) => c.runtimeType == type) as T;

  List<T> getComponents<T extends Component>(Type type) =>
      children.where((c) => c.runtimeType == type).map((e) => e as T).toList();

  T? closestNodeInRange<T extends Node>(
      PositionComponent origin, double range) {
    T? result;
    double minDistance = double.maxFinite;

    for (final Component component in children) {
      if ((component is T) && (component.isAlive)) {
        final double distance = origin.distance(component);

        if ((distance <= range) && (distance < minDistance)) {
          result = component;
          minDistance = distance;
        }
      }
    }

    return result;
  }

  FixedNode? getFixedNode(int i, int j) {
    for (final Component component in children) {
      if ((component is FixedNode) &&
          (component.i == i) &&
          (component.j == j)) {
        return component;
      }
    }

    return null;
  }
}
