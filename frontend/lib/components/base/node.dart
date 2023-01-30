import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/components/game/bullet.dart';
import 'package:tensionnode/extensions/component_extension.dart';
import 'package:tensionnode/game/game_component.dart';
import 'package:tensionnode/services/style.dart';
import 'package:tensionnode/types/weapon_type.dart';

class Node extends SpriteComponent
    with HasGameRef<GameComponent>, CollisionCallbacks {
  final String image;
  final double armor;
  double _shield = Constants.SHIELD_MAX;
  final DebugText debugText = DebugText();

  Node({
    required super.position,
    required this.image,
    required this.armor,
    required double shield,
  }) {
    _shield = shield;
  }

  bool get isAlive => _shield > Constants.SHIELD_MIN;

  @override
  Future onLoad() async {
    sprite = await getSprite(image);
    width = Constants.NODE_SIZE;
    height = Constants.NODE_SIZE;
    anchor = Anchor.center;

    add(CircleHitbox());
    add(debugText);

    return super.onLoad();
  }

  void shoot({
    required WeaponType type,
    required Node target,
  }) {
    final Vector2 direction = (target.position - position).normalized();
    final Vector2 startPosition =
        position + (direction * (Constants.NODE_SIZE / 2));

    FlameAudio.play(type.sound);

    game.addBullet(
      type: type.bullet,
      startPosition: startPosition,
      direction: direction,
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
    _shield -= bullet.type.damage;

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
