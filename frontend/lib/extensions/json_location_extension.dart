import 'package:flame/components.dart';
import 'package:tensionnode/models/location.dart';

typedef JsonLocation = List<int>;

extension JsonLocationExtension on JsonLocation {
  Location get location => Location(
        this[0].toInt(),
        this[1].toInt(),
      );

  static JsonLocation fromPosition(Vector2 position) => [
        position.x.toInt(),
        position.y.toInt(),
      ];
}
