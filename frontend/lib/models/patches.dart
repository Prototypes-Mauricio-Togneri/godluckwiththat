import 'package:tensionplanet/json/json_patches.dart';
import 'package:tensionplanet/models/location.dart';
import 'package:tensionplanet/models/patch.dart';
import 'package:tensionplanet/types/patch_type.dart';
import 'package:tensionplanet/utils/map_list.dart';

class Patches {
  final MapList<PatchType, Patch> _patches = MapList();

  Patches({
    required List<Patch> iron,
    required List<Patch> copper,
    required List<Patch> coal,
    required List<Patch> oil,
    required List<Patch> stone,
  }) {
    _patches.set(PatchType.iron, iron);
    _patches.set(PatchType.copper, copper);
    _patches.set(PatchType.coal, coal);
    _patches.set(PatchType.oil, oil);
    _patches.set(PatchType.stone, stone);
  }

  List<Location> locations(PatchType patchType) =>
      _patches.get(patchType).map((e) => e.location).toList();

  Patch? patchAt(Location location) {
    for (final PatchType patchType in _patches.keys) {
      for (final Patch patch in _patches.get(patchType)) {
        if (patch.isAt(location)) {
          return patch;
        }
      }
    }

    return null;
  }

  JsonPatches get json => JsonPatches(
        iron: _patches.get(PatchType.iron).map((e) => e.json).toList(),
        copper: _patches.get(PatchType.copper).map((e) => e.json).toList(),
        coal: _patches.get(PatchType.coal).map((e) => e.json).toList(),
        oil: _patches.get(PatchType.oil).map((e) => e.json).toList(),
        stone: _patches.get(PatchType.stone).map((e) => e.json).toList(),
      );
}
