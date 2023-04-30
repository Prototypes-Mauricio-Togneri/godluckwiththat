import 'dart:convert';
import 'package:gatewayguardians/types/patch_type.dart';
import 'package:gatewayguardians/types/zone_location.dart';
import 'package:json_annotation/json_annotation.dart';

part 'json_patch.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonPatch {
  @JsonKey(name: 'type')
  final PatchType type;

  @JsonKey(name: 'location')
  final ZoneLocation location;

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
