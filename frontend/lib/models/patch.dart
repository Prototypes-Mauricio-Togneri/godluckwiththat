import 'package:tensionplanet/json/json_patch.dart';
import 'package:tensionplanet/models/location.dart';
import 'package:tensionplanet/types/patch_type.dart';

class Patch {
  final PatchType patchType;
  final Location location;
  int amount;

  Patch({
    required this.patchType,
    required this.location,
    required this.amount,
  });

  bool get isIron => patchType == PatchType.iron;

  bool get isCopper => patchType == PatchType.copper;

  bool get isCoal => patchType == PatchType.coal;

  bool get isOil => patchType == PatchType.oil;

  bool get isStone => patchType == PatchType.stone;

  bool get isWater => patchType == PatchType.stone; // TODO(momo): fix

  bool get isTitanium => patchType == PatchType.stone; // TODO(momo): fix

  bool get isUranium => patchType == PatchType.stone; // TODO(momo): fix

  bool isAt(Location location) => this.location == location;

  JsonPatch get json => JsonPatch(
        location: location.json,
        amount: amount,
      );
}
