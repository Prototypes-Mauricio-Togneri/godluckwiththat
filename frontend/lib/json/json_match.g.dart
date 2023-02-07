// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_match.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonMatch _$JsonMatchFromJson(Map<String, dynamic> json) => JsonMatch(
      version: json['version'] as int,
      id: json['id'] as String,
      timeElapsed: json['timeElapsed'] as int,
      map: JsonMap.fromJson(json['map'] as Map<String, dynamic>),
      mode: JsonMode.fromJson(json['mode'] as Map<String, dynamic>),
      resources:
          JsonResources.fromJson(json['resources'] as Map<String, dynamic>),
      kernel: JsonNode.fromJson(json['kernel'] as Map<String, dynamic>),
      mines: (json['mines'] as List<dynamic>)
          .map((e) => JsonNode.fromJson(e as Map<String, dynamic>))
          .toList(),
      turrets: (json['turrets'] as List<dynamic>)
          .map((e) => JsonTurret.fromJson(e as Map<String, dynamic>))
          .toList(),
      enemies: (json['enemies'] as List<dynamic>)
          .map((e) => JsonEnemy.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$JsonMatchToJson(JsonMatch instance) => <String, dynamic>{
      'version': instance.version,
      'id': instance.id,
      'timeElapsed': instance.timeElapsed,
      'map': instance.map,
      'mode': instance.mode,
      'resources': instance.resources,
      'kernel': instance.kernel,
      'mines': instance.mines,
      'turrets': instance.turrets,
      'enemies': instance.enemies,
    };
