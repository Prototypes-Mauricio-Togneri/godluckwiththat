import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/components/base/fixed_node.dart';

extension ComponentExtension on SpriteComponent {
  Future<Sprite> getSprite(String path) async {
    final Image image = await Flame.images.load(path);

    return Sprite(image);
  }

  Vector2 getSize() {
    final double width =
        Constants.NODE_SIZE * (sprite!.image.width / Constants.BASE_IMAGE_SIZE);
    final double height = Constants.NODE_SIZE *
        (sprite!.image.height / Constants.BASE_IMAGE_SIZE);

    return Vector2(width, height);
  }

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
