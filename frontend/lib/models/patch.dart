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

  JsonPatch get json => JsonPatch(
        location: location.json,
        amount: amount,
      );
}
