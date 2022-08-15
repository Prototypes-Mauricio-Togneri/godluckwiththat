// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_match.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonMatch _$JsonMatchFromJson(Map<String, dynamic> json) => JsonMatch(
      version: json['version'] as int,
      id: json['id'] as String,
      map: JsonMap.fromJson(json['map'] as Map<String, dynamic>),
      nodes: (json['nodes'] as List<dynamic>).map((e) => JsonNode.fromJson(e as Map<String, dynamic>)).toList(),
      lanes: (json['lanes'] as List<dynamic>).map((e) => JsonLane.fromJson(e as Map<String, dynamic>)).toList(),
    );

Map<String, dynamic> _$JsonMatchToJson(JsonMatch instance) => <String, dynamic>{
      'version': instance.version,
      'id': instance.id,
      'map': instance.map,
      'nodes': instance.nodes,
      'lanes': instance.lanes,
    };
