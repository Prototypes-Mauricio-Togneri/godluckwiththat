import 'package:flame/components.dart';
import 'package:tensionnode/extensions/sprite_component_extension.dart';
import 'package:tensionnode/types/resource_type.dart';

class MovingResource extends SpriteComponent {
  final ResourceType resource;

  MovingResource({
    required this.resource,
  });

  @override
  Future onLoad() async {
    sprite = await getSprite(resource.sprite);
    size = getSize();
    anchor = Anchor.center;

    return super.onLoad();
  }
}
