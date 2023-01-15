import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/image_composition.dart';
import 'package:tensionnode/app/constants.dart';

class Mine extends SpriteComponent with Tappable {
  final int i;
  final int j;

  Mine({
    required this.i,
    required this.j,
  }) {
    position = Vector2(
      i * Constants.CELL_SIZE,
      j * Constants.CELL_SIZE,
    );
  }

  @override
  Future<void> onLoad() async {
    final Image image = await Flame.images.load('red_mine.png');
    sprite = Sprite(image);
    width = Constants.CELL_SIZE;
    height = Constants.CELL_SIZE;
    anchor = Anchor.center;
  }

  @override
  bool onTapUp(TapUpInfo info) {
    print('$i $j');

    return true;
  }
}
