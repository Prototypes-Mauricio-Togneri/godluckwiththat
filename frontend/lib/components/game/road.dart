import 'package:flame/components.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/json/json_road.dart';

class Road extends Component {
  final Node nodeA;
  final Node nodeB;

  Road({
    required this.nodeA,
    required this.nodeB,
  });

  @override
  void update(double dt) {
    print('');
    super.update(dt);
  }

  JsonRoad get json => JsonRoad(
        locationA: nodeA.location.json,
        locationB: nodeB.location.json,
      );
}
