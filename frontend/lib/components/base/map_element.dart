import 'package:flame/components.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/components/base/blur_sprite.dart';
import 'package:tensionnode/extensions/component_extension.dart';
import 'package:tensionnode/models/position.dart';

class MapElement extends SpriteComponent {
  final num i;
  final num j;
  final String spriteBase;
  final String spriteBlur;

  MapElement({
    required this.i,
    required this.j,
    required this.spriteBase,
    required this.spriteBlur,
  }) {
    position = Position.fromGrid(i, j);
  }

  @override
  Future onLoad() async {
    sprite = await getSprite(spriteBase);
    width = Constants.NODE_SIZE;
    height = Constants.NODE_SIZE;
    anchor = Anchor.center;

    add(BlurSprite(image: spriteBlur));

    return super.onLoad();
  }
}
