import 'package:flame/components.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/extensions/component_extension.dart';
import 'package:tensionnode/models/position.dart';

class MapElement extends SpriteComponent {
  final num i;
  final num j;
  final String image;

  MapElement({
    required this.i,
    required this.j,
    required this.image,
  }) {
    position = Position.fromGrid(i, j);
  }

  @override
  Future onLoad() async {
    sprite = await getSprite(image);
    width = Constants.NODE_SIZE;
    height = Constants.NODE_SIZE;
    anchor = Anchor.center;

    return super.onLoad();
  }
}
