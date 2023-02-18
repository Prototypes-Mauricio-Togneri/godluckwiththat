// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_woodcutter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonWoodcutter _$JsonWoodcutterFromJson(Map<String, dynamic> json) =>
    JsonWoodcutter(
      location:
          (json['location'] as List<dynamic>).map((e) => e as int).toList(),
      connections:
          JsonConnections.fromJson(json['connections'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$JsonWoodcutterToJson(JsonWoodcutter instance) =>
    <String, dynamic>{
      'location': instance.location,
      'connections': instance.connections,
    };
