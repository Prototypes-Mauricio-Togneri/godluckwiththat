// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_building.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonBuilding _$JsonBuildingFromJson(Map<String, dynamic> json) => JsonBuilding(
      location:
          (json['location'] as List<dynamic>).map((e) => e as int).toList(),
      connections: (json['connections'] as List<dynamic>)
          .map((e) => (e as List<dynamic>).map((e) => e as int).toList())
          .toList(),
    );

Map<String, dynamic> _$JsonBuildingToJson(JsonBuilding instance) =>
    <String, dynamic>{
      'location': instance.location,
      'connections': instance.connections,
    };
