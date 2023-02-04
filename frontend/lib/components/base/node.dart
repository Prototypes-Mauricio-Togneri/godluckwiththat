import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/components/game/bullet.dart';
import 'package:tensionnode/extensions/component_extension.dart';
import 'package:tensionnode/game/game_component.dart';
import 'package:tensionnode/services/style.dart';
import 'package:tensionnode/spec/weapon_spec.dart';
import 'package:tensionnode/types/node_type.dart';

class Node extends SpriteComponent
    with HasGameRef<GameComponent>, CollisionCallbacks {
  final NodeType type;
  final num armor;
  num _shield = Constants.SHIELD_MAX;
  final DebugText debugText = DebugText();

  Node({
    required super.position,
    required this.type,
    required this.armor,
    required num shield,
  }) {
    _shield = shield;
  }

  bool get isAlive => _shield > Constants.SHIELD_MIN;

  @override
  Future onLoad() async {
    sprite = await getSprite(type.spriteBase);
    width = Constants.NODE_SIZE;
    height = Constants.NODE_SIZE;
    anchor = Anchor.center;

    add(CircleHitbox());
    add(NodeBlur(image: type.spriteBlur));
    //add(debugText);

    return super.onLoad();
  }

  void shoot({
    required WeaponSpec spec,
    required Node target,
  }) {
    final Vector2 direction = (target.position - position).normalized();
    final Vector2 startPosition =
        position + (direction * (Constants.NODE_SIZE / 2));

    FlameAudio.play(spec.sound);

    game.addBullet(
      shooter: this,
      spec: spec.bullet,
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

    if ((other is Bullet) && (other.shooter != this)) {
      _hit(other);
    }
  }

  void _hit(Bullet bullet) {
    game.remove(bullet);
    _shield -= bullet.spec.damage;

    if (_shield <= Constants.SHIELD_MIN) {
      destroy();
    }
  }

  void destroy() {
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

class NodeBlur extends SpriteComponent {
  final String image;

  NodeBlur({
    required this.image,
  });

  @override
  Future onLoad() async {
    sprite = await getSprite(image);
    position = Vector2(Constants.NODE_SIZE / 2, Constants.NODE_SIZE / 2);
    width = Constants.NODE_SIZE * (sprite!.image.width / 256);
    height = Constants.NODE_SIZE * (sprite!.image.height / 256);
    anchor = Anchor.center;

    return super.onLoad();
  }
}
