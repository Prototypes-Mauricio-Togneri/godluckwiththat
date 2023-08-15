import 'dart:convert';
import 'package:godluckwiththat/models/inventory.dart';
import 'package:godluckwiththat/types/resource_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'json_colony.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonColony {
  @JsonKey(name: 'owner')
  final String owner;

  @JsonKey(name: 'inventory')
  final JsonInventory inventory;

  @JsonKey(name: 'freeVillagers')
  final int freeVillagers;

  @JsonKey(name: 'color')
  final String color;

  const JsonColony({
    required this.owner,
    required this.inventory,
    required this.freeVillagers,
    required this.color,
  });

  factory JsonColony.fromString(String json) =>
      JsonColony.fromJson(jsonDecode(json));

  factory JsonColony.fromJson(Map<String, dynamic> json) =>
      _$JsonColonyFromJson(json);

  Map<String, dynamic> toJson() => _$JsonColonyToJson(this);

  String toJsonString() => jsonEncode(toJson());
}
