import 'package:flame/components.dart';
import 'package:tensionnode/components/base/fixed_node.dart';

extension ComponentExtension on Component {
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
