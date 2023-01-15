import 'package:flame/palette.dart';
import 'package:tensionnode/engine/mine.dart';
import 'package:tensionnode/engine/zoomable.dart';

class MyGame extends Zoomable {
  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(Mine());
  }

  @override
  Color backgroundColor() => const Color(0xffaaaaaa);
}
