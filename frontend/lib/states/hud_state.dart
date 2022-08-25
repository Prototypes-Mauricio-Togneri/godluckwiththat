import 'package:dafluta/dafluta.dart';
import 'package:tensionnode/engine/fps.dart';
import 'package:tensionnode/model/nodes/headquarters.dart';

class HudState extends BaseState {
  num _resource1 = 0;
  num _resource2 = 0;
  num _resource3 = 0;
  num _energyProduced = 0;
  num _energyConsumed = 0;
  num _fps = 0;

  String get resource1 => _resource1.toInt().toString();

  String get resource2 => _resource2.toInt().toString();

  String get resource3 => _resource3.toInt().toString();

  String get energyProduced => _energyProduced.toString();

  String get energyConsumed => _energyConsumed.toString();

  String get fps => _fps.toString();

  void update({
    required Headquarters headquarters,
    required num energyProduced,
    required num energyConsumed,
    required FPS fps,
  }) {
    _resource1 = headquarters.resource1;
    _resource2 = headquarters.resource2;
    _resource3 = headquarters.resource3;
    _energyProduced = energyProduced;
    _energyConsumed = energyConsumed;
    _fps = fps.fps();
    Delayed.post(notify);
  }
}
