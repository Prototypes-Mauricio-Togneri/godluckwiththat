import 'package:flame/events.dart';
import 'package:tensionnode/components/node.dart';
import 'package:tensionnode/services/assets.dart';

class Headquarters extends Node {
  Headquarters({
    required super.i,
    required super.j,
  }) : super(path: Assets.IMAGES_HQ);

  @override
  bool onTapUp(TapUpInfo info) {
    return true;
  }
}
