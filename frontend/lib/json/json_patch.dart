import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:tensionplanet/types/patch_location.dart';
import 'package:tensionplanet/types/resource_type.dart';

part 'json_patch.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonPatch {
  @JsonKey(name: 'type')
  final ResourceType type;

  @JsonKey(name: 'location')
  final PatchLocation location;

  const JsonPatch({
    required this.type,
    required this.location,
  });

  factory JsonPatch.fromString(String json) =>
      JsonPatch.fromJson(jsonDecode(json));

  factory JsonPatch.fromJson(Map<String, dynamic> json) =>
      _$JsonPatchFromJson(json);

  Map<String, dynamic> toJson() => _$JsonPatchToJson(this);

  String toJsonString() => jsonEncode(toJson());
}
