// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_match.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonMatch _$JsonMatchFromJson(Map<String, dynamic> json) => JsonMatch(
      version: json['version'] as int,
      id: json['id'] as String,
      totalTimeElapsed: json['totalTimeElapsed'] as num,
      level: json['level'] as int,
    );

Map<String, dynamic> _$JsonMatchToJson(JsonMatch instance) => <String, dynamic>{
      'version': instance.version,
      'id': instance.id,
      'totalTimeElapsed': instance.totalTimeElapsed,
      'level': instance.level,
    };
