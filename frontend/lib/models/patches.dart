import 'package:tensionplanet/json/json_patches.dart';
import 'package:tensionplanet/models/location.dart';
import 'package:tensionplanet/models/patch.dart';
import 'package:tensionplanet/types/patch_type.dart';

class Patches {
  final List<Patch> _iron = [];
  final List<Patch> _copper = [];
  final List<Patch> _coal = [];
  final List<Patch> _oil = [];
  final List<Patch> _stone = [];

  Patches({
    required List<Patch> iron,
    required List<Patch> copper,
    required List<Patch> coal,
    required List<Patch> oil,
    required List<Patch> stone,
  }) {
    _iron.addAll(iron);
    _copper.addAll(copper);
    _coal.addAll(coal);
    _oil.addAll(oil);
    _stone.addAll(stone);
  }

  List<Location> locations(PatchType type) {
    if (type == PatchType.iron) {
      return _iron.map((e) => e.location).toList();
    } else if (type == PatchType.copper) {
      return _copper.map((e) => e.location).toList();
    } else if (type == PatchType.coal) {
      return _coal.map((e) => e.location).toList();
    } else if (type == PatchType.oil) {
      return _oil.map((e) => e.location).toList();
    } else if (type == PatchType.stone) {
      return _stone.map((e) => e.location).toList();
    } else {
      throw Exception('Invalid patch type');
    }
  }

  Patch? patchAt(Location location) {
    for (final Patch patch in _iron) {
      if (patch.isAt(location)) {
        return patch;
      }
    }

    for (final Patch patch in _copper) {
      if (patch.isAt(location)) {
        return patch;
      }
    }

    for (final Patch patch in _coal) {
      if (patch.isAt(location)) {
        return patch;
      }
    }

    for (final Patch patch in _stone) {
      if (patch.isAt(location)) {
        return patch;
      }
    }

    return null;
  }

  JsonPatches get json => JsonPatches(
        iron: _iron.map((e) => e.json).toList(),
        copper: _copper.map((e) => e.json).toList(),
        coal: _coal.map((e) => e.json).toList(),
        oil: _oil.map((e) => e.json).toList(),
        stone: _stone.map((e) => e.json).toList(),
      );
}
