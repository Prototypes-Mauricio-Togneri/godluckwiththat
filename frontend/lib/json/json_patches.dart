import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:tensionnode/json/json_patch.dart';

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

  factory JsonPatches.fromString(String json) =>
      JsonPatches.fromJson(jsonDecode(json));

  factory JsonPatches.fromJson(Map<String, dynamic> json) =>
      _$JsonPatchesFromJson(json);

  Map<String, dynamic> toJson() => _$JsonPatchesToJson(this);

  String toJsonString() => jsonEncode(toJson());
}
