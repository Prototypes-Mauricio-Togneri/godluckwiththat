import 'package:flame/input.dart';
import 'package:tensionnode/components/node.dart';
import 'package:tensionnode/dialog/turret_menu.dart';
import 'package:tensionnode/types/turret_type.dart';

class Turret extends Node {
  final TurretType type;

  Turret({
    required super.i,
    required super.j,
    required this.type,
  }) : super(path: type.path);

  @override
  bool onTapUp(TapUpInfo info) {
    if (game.state.deleteMode) {
      game.removeNode(this);
    } else {
      game.openMenu(
        name: TurretMenu.NAME,
        node: this,
      );
    }

    return true;
  }
}
