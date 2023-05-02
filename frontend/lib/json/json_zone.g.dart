// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_zone.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonZone _$JsonZoneFromJson(Map<String, dynamic> json) => JsonZone(
      id: json['id'] as String,
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      owner: json['owner'] as String,
      status: $enumDecode(_$ZoneStatusEnumMap, json['status']),
      patches: (json['patches'] as List<dynamic>)
          .map((e) => JsonPatch.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$JsonZoneToJson(JsonZone instance) => <String, dynamic>{
      'id': instance.id,
      'x': instance.x,
      'y': instance.y,
      'owner': instance.owner,
      'status': _$ZoneStatusEnumMap[instance.status]!,
      'patches': instance.patches,
    };

const _$ZoneStatusEnumMap = {
  ZoneStatus.unexplored: 'unexplored',
  ZoneStatus.explored: 'explored',
};
