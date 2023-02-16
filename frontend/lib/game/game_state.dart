import 'package:dafluta/dafluta.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/components/game/flag.dart';
import 'package:tensionnode/components/game/headquarters.dart';
import 'package:tensionnode/components/game/woodcutter.dart';
import 'package:tensionnode/extensions/num_extension.dart';
import 'package:tensionnode/json/json_match.dart';
import 'package:tensionnode/models/location.dart';

class GameState extends BaseState {
  num _totalTimeElapsed = 0;
  bool loaded = false;

  late final Headquarters headquarters;
  final List<Woodcutter> woodcutters = [];
  final List<Flag> flags = [];
  final JsonMatch jsonMatch;

  GameState(this.jsonMatch) {
    _totalTimeElapsed = jsonMatch.totalTimeElapsed;
  }

  void setLoaded() {
    loaded = true;
    notify();
  }

  void update(double dt) {
    _totalTimeElapsed += dt;
  }

  Node? nodeAt(Location location) {
    if (headquarters.isAt(location)) {
      return headquarters;
    }

    for (final Woodcutter woodcutter in woodcutters) {
      if (woodcutter.isAt(location)) {
        return woodcutter;
      }
    }

    for (final Flag flag in flags) {
      if (flag.isAt(location)) {
        return flag;
      }
    }

    return null;
  }

  void addNode(Component node) {
    if (node is Headquarters) {
      headquarters = node;
    } else if (node is Woodcutter) {
      woodcutters.add(node);
    } else if (node is Flag) {
      flags.add(node);
    }
  }

  void removeNode(Component node) {
    if (node is Woodcutter) {
      woodcutters.remove(node);
    } else if (node is Flag) {
      flags.remove(node);
    }
  }

  JsonMatch getMatch(Camera camera) {
    return JsonMatch(
      version: jsonMatch.version,
      id: jsonMatch.id,
      totalTimeElapsed: _totalTimeElapsed.decimal(),
      map: jsonMatch.map.withCamera(camera),
      headquarters: headquarters.json,
      woodcutters: woodcutters.map((e) => e.json).toList(),
      flags: flags.map((e) => e.json).toList(),
    );
  }
}
