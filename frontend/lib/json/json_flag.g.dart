// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_flag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonFlag _$JsonFlagFromJson(Map<String, dynamic> json) => JsonFlag(
      location:
          (json['location'] as List<dynamic>).map((e) => e as int).toList(),
      queue: (json['queue'] as List<dynamic>)
          .map((e) => $enumDecode(_$ResourceTypeEnumMap, e))
          .toList(),
      connections:
          JsonConnections.fromJson(json['connections'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$JsonFlagToJson(JsonFlag instance) => <String, dynamic>{
      'location': instance.location,
      'queue': instance.queue.map((e) => _$ResourceTypeEnumMap[e]!).toList(),
      'connections': instance.connections,
    };

const _$ResourceTypeEnumMap = {
  ResourceType.timber: 'timber',
  ResourceType.stone: 'stone',
  ResourceType.wood: 'wood',
};
