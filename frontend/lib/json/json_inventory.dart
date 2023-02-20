import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:tensionnode/models/inventory.dart';

part 'json_inventory.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonInventory {
  @JsonKey(name: 'timber')
  final int timber;

  @JsonKey(name: 'stone')
  final int stone;

  @JsonKey(name: 'wood')
  final int wood;

  @JsonKey(name: 'water')
  final int water;

  @JsonKey(name: 'fish')
  final int fish;

  @JsonKey(name: 'meat')
  final int meat;

  const JsonInventory({
    this.timber = 0,
    this.stone = 0,
    this.wood = 0,
    this.water = 0,
    this.fish = 0,
    this.meat = 0,
  });

  Inventory get inventory => Inventory(
        timber: timber,
        stone: stone,
        wood: wood,
        water: water,
        fish: fish,
        meat: meat,
      );

  factory JsonInventory.fromString(String json) =>
      JsonInventory.fromJson(jsonDecode(json));

  factory JsonInventory.fromJson(Map<String, dynamic> json) =>
      _$JsonInventoryFromJson(json);

  Map<String, dynamic> toJson() => _$JsonInventoryToJson(this);
}
