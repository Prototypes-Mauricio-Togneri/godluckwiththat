import 'package:tensionnode/spec/node_spec.dart';
import 'package:tensionnode/types/node_type.dart';

class EnemySpec extends NodeSpec {
  static EnemySpec enemy1 = const EnemySpec(
    type: NodeType.enemy1,
    health: 150,
    speed: 3,
    damage: 100,
    size: 1,
  );

  static EnemySpec enemy2 = const EnemySpec(
    type: NodeType.enemy2,
    health: 200,
    speed: 3,
    damage: 200,
    size: 2,
  );

  static EnemySpec enemy3 = const EnemySpec(
    type: NodeType.enemy3,
    health: 250,
    speed: 3,
    damage: 300,
    size: 3,
  );

  final double speed;
  final double damage;
  final double size;

  const EnemySpec({
    required super.type,
    required super.health,
    required this.speed,
    required this.damage,
    required this.size,
  });
}
