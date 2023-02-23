// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_headquarters.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonHeadquarters _$JsonHeadquartersFromJson(Map<String, dynamic> json) =>
    JsonHeadquarters(
      location:
          (json['location'] as List<dynamic>).map((e) => e as int).toList(),
      inventory:
          JsonInventory.fromJson(json['inventory'] as Map<String, dynamic>),
      connections: (json['connections'] as List<dynamic>)
          .map((e) => (e as List<dynamic>).map((e) => e as int).toList())
          .toList(),
    );

Map<String, dynamic> _$JsonHeadquartersToJson(JsonHeadquarters instance) =>
    <String, dynamic>{
      'location': instance.location,
      'inventory': instance.inventory,
      'connections': instance.connections,
    };
