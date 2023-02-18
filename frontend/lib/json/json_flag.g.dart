// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_flag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonFlag _$JsonFlagFromJson(Map<String, dynamic> json) => JsonFlag(
      location:
          (json['location'] as List<dynamic>).map((e) => e as int).toList(),
      connections:
          JsonConnections.fromJson(json['connections'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$JsonFlagToJson(JsonFlag instance) => <String, dynamic>{
      'location': instance.location,
      'connections': instance.connections,
    };
