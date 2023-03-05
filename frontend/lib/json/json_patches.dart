import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:tensionnode/extensions/json_location_extension.dart';
import 'package:tensionnode/json/json_patch.dart';
import 'package:tensionnode/models/patch.dart';
import 'package:tensionnode/models/patches.dart';
import 'package:tensionnode/types/resource_type.dart';

part 'json_patches.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonPatches {
  @JsonKey(name: 'iron')
  final List<JsonPatch> iron;

  @JsonKey(name: 'copper')
  final List<JsonPatch> copper;

  @JsonKey(name: 'coal')
  final List<JsonPatch> coal;

  @JsonKey(name: 'stone')
  final List<JsonPatch> stone;

  const JsonPatches({
    required this.iron,
    required this.copper,
    required this.coal,
    required this.stone,
  });

  List<Patch> _list(List<JsonPatch> list, ResourceType type) => list
      .map((e) => Patch(
            type: type,
            location: e.location.location,
            amount: e.amount,
          ))
      .toList();

  Patches get patches => Patches(
        iron: _list(iron, ResourceType.iron_ore),
        copper: _list(copper, ResourceType.copper_ore),
        coal: _list(coal, ResourceType.coal_ore),
        stone: _list(stone, ResourceType.stone_ore),
      );

  factory JsonPatches.fromString(String json) =>
      JsonPatches.fromJson(jsonDecode(json));

  factory JsonPatches.fromJson(Map<String, dynamic> json) =>
      _$JsonPatchesFromJson(json);

  Map<String, dynamic> toJson() => _$JsonPatchesToJson(this);

  String toJsonString() => jsonEncode(toJson());
}
