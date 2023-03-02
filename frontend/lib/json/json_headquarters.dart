import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:tensionnode/extensions/json_location_extension.dart';
import 'package:tensionnode/models/inventory.dart';
import 'package:tensionnode/types/resource_type.dart';

part 'json_headquarters.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonHeadquarters {
  @JsonKey(name: 'location')
  final JsonLocation location;

  @JsonKey(name: 'inventory')
  final JsonInventory inventory;

  const JsonHeadquarters({
    required this.location,
    required this.inventory,
  });

  factory JsonHeadquarters.fromString(String json) =>
      JsonHeadquarters.fromJson(jsonDecode(json));

  factory JsonHeadquarters.fromJson(Map<String, dynamic> json) =>
      _$JsonHeadquartersFromJson(json);

  Map<String, dynamic> toJson() => _$JsonHeadquartersToJson(this);
}
