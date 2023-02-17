import 'package:flame/components.dart';
import 'package:tensionnode/extensions/sprite_component_extension.dart';
import 'package:tensionnode/types/resource_type.dart';

class RoutedResource extends SpriteComponent {
  final ResourceType type;

  RoutedResource({
    required this.type,
  });

  @override
  Future onLoad() async {
    sprite = await getSprite(type.sprite);
    size = getSize();
    anchor = Anchor.center;

    return super.onLoad();
  }
}
