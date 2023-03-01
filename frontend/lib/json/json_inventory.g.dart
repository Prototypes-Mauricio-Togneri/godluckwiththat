// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_inventory.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonInventory _$JsonInventoryFromJson(Map<String, dynamic> json) =>
    JsonInventory(
      energy: json['energy'] as int? ?? 0,
      coalOre: json['coal_ore'] as int? ?? 0,
      copperOre: json['copper_ore'] as int? ?? 0,
      copperBlock: json['copper_block'] as int? ?? 0,
    );

Map<String, dynamic> _$JsonInventoryToJson(JsonInventory instance) =>
    <String, dynamic>{
      'energy': instance.energy,
      'coal_ore': instance.coalOre,
      'copper_ore': instance.copperOre,
      'copper_block': instance.copperBlock,
    };
