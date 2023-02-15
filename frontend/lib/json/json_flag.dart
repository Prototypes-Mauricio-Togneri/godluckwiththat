import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:tensionnode/extensions/json_location_extension.dart';
import 'package:tensionnode/json/json_inventory.dart';

part 'json_flag.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonFlag {
  @JsonKey(name: 'location')
  final JsonLocation location;

  @JsonKey(name: 'inventory')
  final JsonInventory inventory;

  const JsonFlag({
    required this.location,
    required this.inventory,
  });

  factory JsonFlag.fromString(String json) =>
      JsonFlag.fromJson(jsonDecode(json));

  factory JsonFlag.fromJson(Map<String, dynamic> json) =>
      _$JsonFlagFromJson(json);

  Map<String, dynamic> toJson() => _$JsonFlagToJson(this);
}
