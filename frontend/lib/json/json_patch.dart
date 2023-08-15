import 'dart:convert';
import 'package:godluckwiththat/json/json_building.dart';
import 'package:godluckwiththat/types/patch_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'json_patch.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonPatch {
  @JsonKey(name: 'patch_type')
  final PatchType patchType;

  @JsonKey(name: 'building')
  final JsonBuilding? building;

  const JsonPatch({
    required this.patchType,
    required this.building,
  });

  factory JsonPatch.fromString(String json) =>
      JsonPatch.fromJson(jsonDecode(json));

  factory JsonPatch.fromJson(Map<String, dynamic> json) =>
      _$JsonPatchFromJson(json);

  Map<String, dynamic> toJson() => _$JsonPatchToJson(this);

  String toJsonString() => jsonEncode(toJson());
}
