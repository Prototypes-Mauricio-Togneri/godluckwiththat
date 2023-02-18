// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_sawmill.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonSawmill _$JsonSawmillFromJson(Map<String, dynamic> json) => JsonSawmill(
      location:
          (json['location'] as List<dynamic>).map((e) => e as int).toList(),
      connections:
          JsonConnections.fromJson(json['connections'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$JsonSawmillToJson(JsonSawmill instance) =>
    <String, dynamic>{
      'location': instance.location,
      'connections': instance.connections,
    };
