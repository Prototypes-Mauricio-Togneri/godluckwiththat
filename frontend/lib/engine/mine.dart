import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:tensionnode/engine/cell.dart';

class Mine extends Cell with Tappable {
  Mine({
    required super.i,
    required super.j,
    required super.path,
  });

  @override
  bool onTapUp(TapUpInfo info) {
    print('$i $j');

    return true;
  }
}
