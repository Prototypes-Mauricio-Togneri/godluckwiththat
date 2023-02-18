import 'package:flame/components.dart';
import 'package:tensionnode/extensions/sprite_component_extension.dart';
import 'package:tensionnode/models/routed_resource.dart';

class MovingResource extends SpriteComponent {
  final RoutedResource routedResource;

  MovingResource({
    required this.routedResource,
  });

  @override
  Future onLoad() async {
    sprite = await getSprite(routedResource.resource.sprite);
    size = getSize();
    anchor = Anchor.center;

    return super.onLoad();
  }
}
