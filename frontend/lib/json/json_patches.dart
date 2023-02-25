import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:tensionnode/json/json_patch.dart';

part 'json_patches.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonPatches {
  @JsonKey(name: 'coal')
  final List<JsonPatch> coal;

  @JsonKey(name: 'copper')
  final List<JsonPatch> copper;

  const JsonPatches({
    required this.coal,
    required this.copper,
  });

  factory JsonPatches.fromString(String json) =>
      JsonPatches.fromJson(jsonDecode(json));

  factory JsonPatches.fromJson(Map<String, dynamic> json) =>
      _$JsonPatchesFromJson(json);

  Map<String, dynamic> toJson() => _$JsonPatchesToJson(this);

  String toJsonString() => jsonEncode(toJson());
}
