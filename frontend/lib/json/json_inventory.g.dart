// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_inventory.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonInventory _$JsonInventoryFromJson(Map<String, dynamic> json) =>
    JsonInventory(
      coalOre: json['coal_ore'] as int? ?? 0,
      cooperOre: json['cooper_ore'] as int? ?? 0,
      cooperBlock: json['cooper_block'] as int? ?? 0,
    );

Map<String, dynamic> _$JsonInventoryToJson(JsonInventory instance) =>
    <String, dynamic>{
      'coal_ore': instance.coalOre,
      'cooper_ore': instance.cooperOre,
      'cooper_block': instance.cooperBlock,
    };
