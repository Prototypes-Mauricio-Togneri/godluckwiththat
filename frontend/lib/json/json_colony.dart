import 'dart:convert';
import 'package:gatewayguardians/models/inventory.dart';
import 'package:gatewayguardians/types/resource_type.dart';
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

  const JsonColony({
    required this.owner,
    required this.inventory,
    required this.freeVillagers,
  });

  factory JsonColony.fromString(String json) =>
      JsonColony.fromJson(jsonDecode(json));

  factory JsonColony.fromJson(Map<String, dynamic> json) =>
      _$JsonColonyFromJson(json);

  Map<String, dynamic> toJson() => _$JsonColonyToJson(this);

  String toJsonString() => jsonEncode(toJson());
}
