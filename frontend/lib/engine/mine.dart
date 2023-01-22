import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:tensionnode/dialog/main_menu.dart';
import 'package:tensionnode/engine/cell.dart';
import 'package:tensionnode/types/resource_type.dart';

class Mine extends Cell with Tappable {
  final ResourceType resourceType;
  num accumulatedTime = 0;

  static const int RESOURCE_RED_COST = 100;

  Mine({
    required super.i,
    required super.j,
    required this.resourceType,
  }) : super(path: resourceType.pathMine);

  @override
  void update(double dt) {
    accumulatedTime += dt;

    if (accumulatedTime >= resourceType.productionTime) {
      accumulatedTime = 0;
      game.state.addResource(resourceType);
    }

    super.update(dt);
  }

  @override
  bool onTapUp(TapUpInfo info) {
    print('$i $j');

    MainMenu.show(
      game: game,
      onContinue: () {},
      onLoad: () {},
      onSave: () {},
      onSettings: () {},
    );

    return true;
  }
}
