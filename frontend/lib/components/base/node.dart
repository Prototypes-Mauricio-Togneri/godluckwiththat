import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/components/game/bullet.dart';
import 'package:tensionnode/extensions/component_extension.dart';
import 'package:tensionnode/game/game_component.dart';
import 'package:tensionnode/services/style.dart';

class Node extends SpriteComponent
    with HasGameRef<GameComponent>, CollisionCallbacks {
  final String path;
  final double armor;
  double _shield = Constants.SHIELD_MAX;
  final DebugText debugText = DebugText();

  Node({
    required super.position,
    required this.path,
    required this.armor,
    required double shield,
  }) {
    _shield = shield;
  }

  bool get isAlive => _shield > Constants.SHIELD_MIN;

  @override
  Future onLoad() async {
    sprite = await getSprite(path);
    width = Constants.NODE_SIZE;
    height = Constants.NODE_SIZE;
    anchor = Anchor.center;

    add(CircleHitbox());
    add(debugText);

    return super.onLoad();
  }

  void shoot({
    required Node target,
    required double range,
    required double damage,
  }) {
    final Vector2 direction = (target.position - position).normalized();
    final Vector2 originalPosition =
        position + (direction * (Constants.NODE_SIZE / 2));

    game.addBullet(
      position: originalPosition,
      direction: direction,
      range: range * 1.5,
      damage: damage,
    );
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is Bullet) {
      _hit(other);
    }
  }

  void _hit(Bullet bullet) {
    game.remove(bullet);
    _shield -= bullet.damage;

    if (_shield <= Constants.SHIELD_MIN) {
      kill();
    }
  }

  void kill() {
    _shield = 0;
    game.removeNode(this);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if ((_shield > Constants.SHIELD_MIN) && (_shield < Constants.SHIELD_MAX)) {
      _shield += dt * armor;
      _shield = _shield.clamp(Constants.SHIELD_MIN, Constants.SHIELD_MAX);
    }

    debugText.text = '${_shield.toInt()}';
  }
}

class DebugText extends TextComponent {
  DebugText() {
    position = Vector2(Constants.NODE_SIZE / 2, Constants.NODE_SIZE / 2);
    anchor = Anchor.center;
    textRenderer = Style.debugTextRenderer(size: 5);
  }
}
