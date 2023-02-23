// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_transformer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonTransformer _$JsonTransformerFromJson(Map<String, dynamic> json) =>
    JsonTransformer(
      location:
          (json['location'] as List<dynamic>).map((e) => e as int).toList(),
      connections: (json['connections'] as List<dynamic>)
          .map((e) => (e as List<dynamic>).map((e) => e as int).toList())
          .toList(),
    );

Map<String, dynamic> _$JsonTransformerToJson(JsonTransformer instance) =>
    <String, dynamic>{
      'location': instance.location,
      'connections': instance.connections,
    };
