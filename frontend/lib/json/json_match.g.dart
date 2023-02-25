// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_match.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonMatch _$JsonMatchFromJson(Map<String, dynamic> json) => JsonMatch(
      version: json['version'] as int,
      id: json['id'] as String,
      totalTimeElapsed: json['totalTimeElapsed'] as num,
      map: JsonMap.fromJson(json['map'] as Map<String, dynamic>),
      coalMines: (json['coal_mines'] as List<dynamic>)
          .map((e) => JsonProducer.fromJson(e as Map<String, dynamic>))
          .toList(),
      cooperMines: (json['cooper_mines'] as List<dynamic>)
          .map((e) => JsonProducer.fromJson(e as Map<String, dynamic>))
          .toList(),
      cooperFurnaces: (json['cooper_furnaces'] as List<dynamic>)
          .map((e) => JsonTransformer.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$JsonMatchToJson(JsonMatch instance) => <String, dynamic>{
      'version': instance.version,
      'id': instance.id,
      'totalTimeElapsed': instance.totalTimeElapsed,
      'map': instance.map,
      'coal_mines': instance.coalMines,
      'cooper_mines': instance.cooperMines,
      'cooper_furnaces': instance.cooperFurnaces,
    };
