// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_mill.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonMill _$JsonMillFromJson(Map<String, dynamic> json) => JsonMill(
      location:
          (json['location'] as List<dynamic>).map((e) => e as int).toList(),
      connections:
          JsonConnections.fromJson(json['connections'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$JsonMillToJson(JsonMill instance) => <String, dynamic>{
      'location': instance.location,
      'connections': instance.connections,
    };
