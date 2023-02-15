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
    );

Map<String, dynamic> _$JsonInventoryToJson(JsonInventory instance) =>
    <String, dynamic>{
      'timber': instance.timber,
      'stone': instance.stone,
      'wood': instance.wood,
    };
