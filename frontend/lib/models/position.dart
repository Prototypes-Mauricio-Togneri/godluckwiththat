import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/extensions/json_position_extension.dart';
import 'package:tensionnode/extensions/num_extension.dart';

class Position {
  static Vector2 fromGrid(num i, num j) => Vector2(
        i * Constants.NODE_SIZE,
        j * Constants.NODE_SIZE,
      );

  static JsonPosition json(Vector2 position) => [
        position.x.decimal(),
        position.y.decimal(),
      ];
}
