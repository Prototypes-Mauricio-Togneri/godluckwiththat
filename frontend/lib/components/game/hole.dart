import 'package:tensionnode/components/base/map_element.dart';
import 'package:tensionnode/services/assets.dart';

class Hole extends MapElement {
  Hole({
    required super.i,
    required super.j,
  }) : super(spritePath: Assets.IMAGES_HOLE);
}
