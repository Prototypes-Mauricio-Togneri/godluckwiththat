import 'package:tensionnode/json/json_patch.dart';
import 'package:tensionnode/models/location.dart';
import 'package:tensionnode/types/resource_type.dart';

class Patch {
  final ResourceType type;
  final Location location;
  int amount;

  Patch({
    required this.type,
    required this.location,
    required this.amount,
  });

  bool get isIron => type == ResourceType.iron_ore;

  bool get isCopper => type == ResourceType.copper_ore;

  bool get isCoal => type == ResourceType.coal_ore;

  bool get isStone => type == ResourceType.stone_ore;

  bool isAt(Location location) => this.location == location;

  JsonPatch get json => JsonPatch(
        location: location.json,
        amount: amount,
      );
}
