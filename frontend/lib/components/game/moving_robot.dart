import 'package:flame/components.dart';
import 'package:tensionnode/extensions/sprite_component_extension.dart';
import 'package:tensionnode/models/routed_robot.dart';

class MovingRobot extends SpriteComponent {
  final RoutedRobot routedRobot;

  MovingRobot({
    required this.routedRobot,
  });

  @override
  Future onLoad() async {
    //sprite = await getSprite(routedRobot.resource.sprite);
    size = getSize();
    anchor = Anchor.center;

    return super.onLoad();
  }
}
