// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_sawery.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonSawery _$JsonSaweryFromJson(Map<String, dynamic> json) => JsonSawery(
      location:
          (json['location'] as List<dynamic>).map((e) => e as int).toList(),
      connections:
          JsonConnections.fromJson(json['connections'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$JsonSaweryToJson(JsonSawery instance) =>
    <String, dynamic>{
      'location': instance.location,
      'connections': instance.connections,
    };
