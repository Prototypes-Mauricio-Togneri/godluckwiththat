// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_match.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonMatch _$JsonMatchFromJson(Map<String, dynamic> json) => JsonMatch(
      version: json['version'] as num,
      id: json['id'] as String,
      resources:
          JsonResources.fromJson(json['resources'] as Map<String, dynamic>),
      patches: (json['patches'] as List<dynamic>)
          .map((e) => JsonPatch.fromJson(e as Map<String, dynamic>))
          .toList(),
      kernel: JsonNode.fromJson(json['kernel'] as Map<String, dynamic>),
      mines: (json['mines'] as List<dynamic>)
          .map((e) => JsonNode.fromJson(e as Map<String, dynamic>))
          .toList(),
      turrets: (json['turrets'] as List<dynamic>)
          .map((e) => JsonNode.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$JsonMatchToJson(JsonMatch instance) => <String, dynamic>{
      'version': instance.version,
      'id': instance.id,
      'resources': instance.resources,
      'patches': instance.patches,
      'kernel': instance.kernel,
      'mines': instance.mines,
      'turrets': instance.turrets,
    };
