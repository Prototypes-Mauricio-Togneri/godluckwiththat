import 'package:flame/components.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/models/location.dart';

extension ComponentExtension on Component {
  void removeComponents(Type type) => removeWhere((c) {
        c.removeWhere((c) => c.runtimeType == type);

        return c.runtimeType == type;
      });

  T getComponent<T extends Component>(Type type) =>
      children.singleWhere((c) => c.runtimeType == type) as T;

  Node? getNode(Location location) {
    for (final Component component in children) {
      if ((component is Node) && (component.location == location)) {
        return component;
      }
    }

    return null;
  }
}
