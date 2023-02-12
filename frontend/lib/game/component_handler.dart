import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:tensionnode/components/base/fixed_node.dart';

mixin ComponentHandler on FlameGame {
  //bool hasComponent(Type type) => children.any((c) => c.runtimeType == type);

  //List<T> getComponents<T extends Component>(Type type) =>
  //    children.where((c) => c.runtimeType == type).map((e) => e as T).toList();

  void removeComponents(Type type) => removeWhere((c) {
        c.removeWhere((c) => c.runtimeType == type);

        return c.runtimeType == type;
      });

  T getComponent<T extends Component>(Type type) =>
      children.singleWhere((c) => c.runtimeType == type) as T;

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
