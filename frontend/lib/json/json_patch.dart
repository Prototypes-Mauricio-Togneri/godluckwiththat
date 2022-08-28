import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:tensionnode/extensions/json_position_extension.dart';
import 'package:tensionnode/model/patch.dart';
import 'package:tensionnode/types/resource_type.dart';

part 'json_patch.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonPatch {
  @JsonKey(name: 'resource')
  final ResourceType resource;

  @JsonKey(name: 'position')
  final JsonPosition position;

  const JsonPatch({
    required this.resource,
    required this.position,
  });

  Patch getPatch() => Patch(
        type: resource,
        position: position.position,
      );

  factory JsonPatch.fromString(String json) => JsonPatch.fromJson(jsonDecode(json));

  factory JsonPatch.fromJson(Map<String, dynamic> json) => _$JsonPatchFromJson(json);

  Map<String, dynamic> toJson() => _$JsonPatchToJson(this);
}
