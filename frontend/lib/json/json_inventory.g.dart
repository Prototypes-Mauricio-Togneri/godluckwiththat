// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_inventory.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonInventory _$JsonInventoryFromJson(Map<String, dynamic> json) =>
    JsonInventory(
      timber: json['timber'] as int? ?? 0,
      stone: json['stone'] as int? ?? 0,
      wood: json['wood'] as int? ?? 0,
      water: json['water'] as int? ?? 0,
      fish: json['fish'] as int? ?? 0,
      meat: json['meat'] as int? ?? 0,
      grain: json['grain'] as int? ?? 0,
      flour: json['flour'] as int? ?? 0,
      bread: json['bread'] as int? ?? 0,
    );

Map<String, dynamic> _$JsonInventoryToJson(JsonInventory instance) =>
    <String, dynamic>{
      'timber': instance.timber,
      'stone': instance.stone,
      'wood': instance.wood,
      'water': instance.water,
      'fish': instance.fish,
      'meat': instance.meat,
      'grain': instance.grain,
      'flour': instance.flour,
      'bread': instance.bread,
    };
