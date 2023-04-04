import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:tensionplanet/extensions/json_location_extension.dart';
import 'package:tensionplanet/json/json_patch.dart';
import 'package:tensionplanet/models/patch.dart';
import 'package:tensionplanet/models/patches.dart';
import 'package:tensionplanet/types/patch_type.dart';

part 'json_patches.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonPatches {
  @JsonKey(name: 'iron')
  final List<JsonPatch> iron;

  @JsonKey(name: 'copper')
  final List<JsonPatch> copper;

  @JsonKey(name: 'stone')
  final List<JsonPatch> stone;

  @JsonKey(name: 'water')
  final List<JsonPatch> water;

  @JsonKey(name: 'coal')
  final List<JsonPatch> coal;

  @JsonKey(name: 'oil')
  final List<JsonPatch> oil;

  @JsonKey(name: 'titanium')
  final List<JsonPatch> titanium;

  @JsonKey(name: 'uranium')
  final List<JsonPatch> uranium;

  const JsonPatches({
    required this.iron,
    required this.copper,
    required this.stone,
    required this.water,
    required this.coal,
    required this.oil,
    required this.titanium,
    required this.uranium,
  });

  List<Patch> _list(List<JsonPatch> list, PatchType patchType) => list
      .map((e) => Patch(
            patchType: patchType,
            location: e.location.location,
            amount: e.amount,
          ))
      .toList();

  Patches get patches => Patches(
        iron: _list(iron, PatchType.iron),
        copper: _list(copper, PatchType.copper),
        stone: _list(stone, PatchType.stone),
        water: _list(stone, PatchType.water),
        coal: _list(coal, PatchType.coal),
        oil: _list(oil, PatchType.oil),
        titanium: _list(oil, PatchType.titanium),
        uranium: _list(oil, PatchType.uranium),
      );

  factory JsonPatches.fromString(String json) =>
      JsonPatches.fromJson(jsonDecode(json));

  factory JsonPatches.fromJson(Map<String, dynamic> json) =>
      _$JsonPatchesFromJson(json);

  Map<String, dynamic> toJson() => _$JsonPatchesToJson(this);

  String toJsonString() => jsonEncode(toJson());
}
