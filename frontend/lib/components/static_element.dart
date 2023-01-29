import 'package:flame/components.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/extensions/component_extension.dart';
import 'package:tensionnode/models/position.dart';

class StaticElement extends SpriteComponent {
  final int i;
  final int j;
  final String path;

  StaticElement({
    required this.i,
    required this.j,
    required this.path,
  }) {
    position = Position.fromGrid(i, j);
  }

  @override
  Future onLoad() async {
    sprite = await getSprite(path);
    width = Constants.NODE_SIZE;
    height = Constants.NODE_SIZE;
    anchor = Anchor.center;

    return super.onLoad();
  }
}
