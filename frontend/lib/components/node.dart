import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/components/bullet.dart';
import 'package:tensionnode/extensions/component_extension.dart';
import 'package:tensionnode/game/game_component.dart';

class Node extends SpriteComponent
    with HasGameRef<GameComponent>, Tappable, CollisionCallbacks {
  final int i;
  final int j;
  final String path;
  final double armor = 10;
  double _shield = Constants.SHIELD_MAX; // TODO(momo): pass as parameter

  Node({
    required this.i,
    required this.j,
    required this.path,
  }) {
    position = Vector2(
      i * Constants.NODE_SIZE,
      j * Constants.NODE_SIZE,
    );
  }

  bool get isAlive => _shield > Constants.SHIELD_MIN;

  @override
  Future onLoad() async {
    sprite = await getSprite(path);
    width = Constants.NODE_SIZE;
    height = Constants.NODE_SIZE;
    anchor = Anchor.center;

    add(CircleHitbox());

    return super.onLoad();
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
      game.removeNode(this);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if ((_shield > Constants.SHIELD_MIN) && (_shield < Constants.SHIELD_MAX)) {
      _shield += dt / (100 / armor);
      _shield = _shield.clamp(Constants.SHIELD_MIN, Constants.SHIELD_MAX);
    }
  }

  @override
  bool onTapUp(TapUpInfo info) => false;

  @override
  bool onTapDown(TapDownInfo info) => false;
}
