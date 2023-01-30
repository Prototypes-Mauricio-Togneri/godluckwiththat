import 'package:tensionnode/services/assets.dart';
import 'package:tensionnode/types/weapon_type.dart';

enum EnemyType {
  enemy(
    image: Assets.IMAGES_ENEMY,
    armor: 50,
    speed: 50,
    weapon: WeaponType.enemy,
  );

  final String image;
  final double armor;
  final double speed;
  final WeaponType weapon;

  const EnemyType({
    required this.image,
    required this.armor,
    required this.speed,
    required this.weapon,
  });
}
