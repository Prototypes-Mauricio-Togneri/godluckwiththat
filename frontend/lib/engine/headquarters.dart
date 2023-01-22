import 'package:flame/events.dart';
import 'package:tensionnode/dialog/main_menu.dart';
import 'package:tensionnode/engine/cell.dart';

class Headquarters extends Cell {
  Headquarters({
    required super.i,
    required super.j,
  }) : super(path: 'hq.png');

  @override
  bool onTapUp(TapUpInfo info) {
    print('$i $j');

    MainMenu.show(game: game);

    return true;
  }
}
