// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_bakery.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonBakery _$JsonBakeryFromJson(Map<String, dynamic> json) => JsonBakery(
      location:
          (json['location'] as List<dynamic>).map((e) => e as int).toList(),
      connections:
          JsonConnections.fromJson(json['connections'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$JsonBakeryToJson(JsonBakery instance) =>
    <String, dynamic>{
      'location': instance.location,
      'connections': instance.connections,
    };
