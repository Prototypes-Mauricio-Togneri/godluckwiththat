import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:tensionnode/engine/game_state.dart';

class Hud extends SpriteComponent with Tappable {
  final double xPosition;
  final GameState gameState;
  final TextComponent redAmount = TextComponent();

  Hud({
    required this.xPosition,
    required this.gameState,
  }) {
    positionType = PositionType.viewport;
    priority = 1;
  }

  @override
  Future onLoad() async {
    final Image image = await Flame.images.load('hud.png');
    sprite = Sprite(image);
    position = Vector2(xPosition, 25);
    width = 100;
    height = 50;
    anchor = Anchor.center;

    add(redAmount);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    redAmount.text = 'Red: ${gameState.red}';
  }
}
