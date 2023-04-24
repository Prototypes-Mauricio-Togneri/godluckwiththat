import 'package:flame/components.dart';

extension ComponentExtension on Component {
  void removeComponents(Type type) => removeWhere((c) => c.runtimeType == type);

  void removeAllComponents() => removeWhere((c) => true);

  T getComponent<T extends Component>(Type type) =>
      children.singleWhere((c) => c.runtimeType == type) as T;

  List<Component> getComponents<T extends Component>(Type type) =>
      children.where((c) => c.runtimeType == type).toList();
}
