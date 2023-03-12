import 'package:tensionplanet/json/json_patch.dart';
import 'package:tensionplanet/models/location.dart';
import 'package:tensionplanet/types/patch_type.dart';

class Patch {
  final PatchType type;
  final Location location;
  int amount;

  Patch({
    required this.type,
    required this.location,
    required this.amount,
  });

  bool get isIron => type == PatchType.iron;

  bool get isCopper => type == PatchType.copper;

  bool get isCoal => type == PatchType.coal;

  bool get isOil => type == PatchType.oil;

  bool get isStone => type == PatchType.stone;

  bool isAt(Location location) => this.location == location;

  JsonPatch get json => JsonPatch(
        location: location.json,
        amount: amount,
      );
}
