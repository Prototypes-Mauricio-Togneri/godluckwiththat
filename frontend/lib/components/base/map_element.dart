import 'package:flame/components.dart';
import 'package:tensionnode/extensions/component_extension.dart';
import 'package:tensionnode/models/position.dart';

class MapElement extends SpriteComponent {
  final num i;
  final num j;
  final String spritePath;

  MapElement({
    required this.i,
    required this.j,
    required this.spritePath,
  }) {
    position = Position.fromGrid(i, j);
  }

  @override
  Future onLoad() async {
    sprite = await getSprite(spritePath);
    size = getSize();
    anchor = Anchor.center;

    return super.onLoad();
  }
}
