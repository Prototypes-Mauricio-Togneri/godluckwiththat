import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:tensionnode/app/constants.dart';

class Position {
  static Vector2 fromGrid(int i, int j) => Vector2(
        i * Constants.NODE_SIZE,
        j * Constants.NODE_SIZE,
      );
}
