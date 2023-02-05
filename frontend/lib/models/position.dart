import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/extensions/json_position_extension.dart';

class Position {
  static Vector2 fromGrid(num i, num j) => Vector2(
        i * Constants.NODE_SIZE,
        j * Constants.NODE_SIZE,
      );

  static JsonPosition json(Vector2 position) => [
        num.parse(position.x.toStringAsFixed(2)),
        num.parse(position.y.toStringAsFixed(2)),
      ];
}
