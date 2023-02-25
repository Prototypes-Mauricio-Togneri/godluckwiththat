import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:tensionnode/models/inventory.dart';

part 'json_inventory.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonInventory {
  @JsonKey(name: 'coal_ore')
  final int coalOre;

  @JsonKey(name: 'copper_ore')
  final int copperOre;

  @JsonKey(name: 'copper_block')
  final int copperBlock;

  const JsonInventory({
    this.coalOre = 0,
    this.copperOre = 0,
    this.copperBlock = 0,
  });

  Inventory get inventory => Inventory.fromList(
        coalOre: coalOre,
        copperOre: copperOre,
        copperBlock: copperBlock,
      );

  factory JsonInventory.fromString(String json) =>
      JsonInventory.fromJson(jsonDecode(json));

  factory JsonInventory.fromJson(Map<String, dynamic> json) =>
      _$JsonInventoryFromJson(json);

  Map<String, dynamic> toJson() => _$JsonInventoryToJson(this);
}
