import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:tensionplanet/extensions/json_location_extension.dart';

part 'json_patch.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonPatch {
  @JsonKey(name: 'location')
  final JsonLocation location;

  @JsonKey(name: 'amount')
  final int amount;

  const JsonPatch({
    required this.location,
    required this.amount,
  });

  factory JsonPatch.fromString(String json) =>
      JsonPatch.fromJson(jsonDecode(json));

  factory JsonPatch.fromJson(Map<String, dynamic> json) =>
      _$JsonPatchFromJson(json);

  Map<String, dynamic> toJson() => _$JsonPatchToJson(this);

  String toJsonString() => jsonEncode(toJson());
}
