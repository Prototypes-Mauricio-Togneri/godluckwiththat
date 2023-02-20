import 'package:dafluta/dafluta.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/components/game/flag.dart';
import 'package:tensionnode/components/game/headquarters.dart';
import 'package:tensionnode/components/game/producers/crop_farm.dart';
import 'package:tensionnode/components/game/producers/fisher.dart';
import 'package:tensionnode/components/game/producers/hunter.dart';
import 'package:tensionnode/components/game/producers/quarry.dart';
import 'package:tensionnode/components/game/producers/well.dart';
import 'package:tensionnode/components/game/producers/woodcutter.dart';
import 'package:tensionnode/components/game/transformers/mill.dart';
import 'package:tensionnode/components/game/transformers/sawery.dart';
import 'package:tensionnode/extensions/num_extension.dart';
import 'package:tensionnode/json/json_match.dart';
import 'package:tensionnode/models/location.dart';
import 'package:tensionnode/models/resource_manager.dart';

class GameState extends BaseState {
  num _totalTimeElapsed = 0;
  bool loaded = false;

  late final Headquarters headquarters;
  final List<Woodcutter> woodcutters = [];
  final List<Quarry> quarries = [];
  final List<Well> wells = [];
  final List<Fisher> fishers = [];
  final List<Hunter> hunters = [];
  final List<CropFarm> cropFarms = [];
  final List<Sawery> saweries = [];
  final List<Mill> mills = [];
  final List<Flag> flags = [];
  final JsonMatch jsonMatch;
  final ResourceManager resourceManager = ResourceManager();

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

  Node nodeAt(Location location) {
    if (headquarters.isAt(location)) {
      return headquarters;
    }

    for (final Woodcutter woodcutter in woodcutters) {
      if (woodcutter.isAt(location)) {
        return woodcutter;
      }
    }

    for (final Quarry quarry in quarries) {
      if (quarry.isAt(location)) {
        return quarry;
      }
    }

    for (final Well well in wells) {
      if (well.isAt(location)) {
        return well;
      }
    }

    for (final Fisher fisher in fishers) {
      if (fisher.isAt(location)) {
        return fisher;
      }
    }

    for (final Hunter hunter in hunters) {
      if (hunter.isAt(location)) {
        return hunter;
      }
    }

    for (final CropFarm cropFarm in cropFarms) {
      if (cropFarm.isAt(location)) {
        return cropFarm;
      }
    }

    for (final Sawery sawery in saweries) {
      if (sawery.isAt(location)) {
        return sawery;
      }
    }

    for (final Mill mill in mills) {
      if (mill.isAt(location)) {
        return mill;
      }
    }

    for (final Flag flag in flags) {
      if (flag.isAt(location)) {
        return flag;
      }
    }

    throw Exception('Node at $location cannot be found');
  }

  void addNode(Component node) {
    if (node is Headquarters) {
      headquarters = node;
    } else if (node is Woodcutter) {
      woodcutters.add(node);
    } else if (node is Quarry) {
      quarries.add(node);
    } else if (node is Well) {
      wells.add(node);
    } else if (node is Fisher) {
      fishers.add(node);
    } else if (node is Hunter) {
      hunters.add(node);
    } else if (node is CropFarm) {
      cropFarms.add(node);
    } else if (node is Sawery) {
      saweries.add(node);
    } else if (node is Mill) {
      mills.add(node);
    } else if (node is Flag) {
      flags.add(node);
    }
  }

  void removeNode(Component node) {
    if (node is Woodcutter) {
      woodcutters.remove(node);
    } else if (node is Quarry) {
      quarries.remove(node);
    } else if (node is Well) {
      wells.remove(node);
    } else if (node is Fisher) {
      fishers.remove(node);
    } else if (node is Hunter) {
      hunters.remove(node);
    } else if (node is CropFarm) {
      cropFarms.remove(node);
    } else if (node is Sawery) {
      saweries.remove(node);
    } else if (node is Mill) {
      mills.remove(node);
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
      quarries: quarries.map((e) => e.json).toList(),
      wells: wells.map((e) => e.json).toList(),
      fishers: fishers.map((e) => e.json).toList(),
      hunters: hunters.map((e) => e.json).toList(),
      cropFarms: cropFarms.map((e) => e.json).toList(),
      saweries: saweries.map((e) => e.json).toList(),
      mills: mills.map((e) => e.json).toList(),
      flags: flags.map((e) => e.json).toList(),
    );
  }
}
