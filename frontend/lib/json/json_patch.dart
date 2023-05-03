import 'dart:convert';
import 'package:gatewayguardians/json/json_building.dart';
import 'package:gatewayguardians/types/patch_type.dart';
import 'package:gatewayguardians/types/zone_location.dart';
import 'package:json_annotation/json_annotation.dart';

part 'json_patch.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonPatch {
  @JsonKey(name: 'patch_type')
  final PatchType patchType;

  @JsonKey(name: 'location')
  final ZoneLocation location;

  @JsonKey(name: 'building')
  final JsonBuilding? building;

  const JsonPatch({
    required this.patchType,
    required this.location,
    required this.building,
  });

  factory JsonPatch.fromString(String json) =>
      JsonPatch.fromJson(jsonDecode(json));

  factory JsonPatch.fromJson(Map<String, dynamic> json) =>
      _$JsonPatchFromJson(json);

  Map<String, dynamic> toJson() => _$JsonPatchToJson(this);

  String toJsonString() => jsonEncode(toJson());
}
