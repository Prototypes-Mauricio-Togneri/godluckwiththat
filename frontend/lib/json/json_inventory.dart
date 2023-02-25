import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:tensionnode/models/inventory.dart';

part 'json_inventory.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonInventory {
  @JsonKey(name: 'coal_ore')
  final int coalOre;

  @JsonKey(name: 'cooper_ore')
  final int cooperOre;

  @JsonKey(name: 'cooper_block')
  final int cooperBlock;

  const JsonInventory({
    this.coalOre = 0,
    this.cooperOre = 0,
    this.cooperBlock = 0,
  });

  Inventory get inventory => Inventory.fromList(
        coalOre: coalOre,
        cooperOre: cooperOre,
        cooperBlock: cooperBlock,
      );

  factory JsonInventory.fromString(String json) =>
      JsonInventory.fromJson(jsonDecode(json));

  factory JsonInventory.fromJson(Map<String, dynamic> json) =>
      _$JsonInventoryFromJson(json);

  Map<String, dynamic> toJson() => _$JsonInventoryToJson(this);
}
