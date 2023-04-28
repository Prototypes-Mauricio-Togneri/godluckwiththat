// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_zone.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonZone _$JsonZoneFromJson(Map<String, dynamic> json) => JsonZone(
      id: json['id'] as String,
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      maxBuildings: json['maxBuildings'] as int,
      status: $enumDecode(_$ZoneStatusEnumMap, json['status']),
      patches: (json['patches'] as List<dynamic>)
          .map((e) => JsonPatch.fromJson(e as Map<String, dynamic>))
          .toList(),
      buildings: (json['buildings'] as List<dynamic>)
          .map((e) => JsonBuilding.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$JsonZoneToJson(JsonZone instance) => <String, dynamic>{
      'id': instance.id,
      'x': instance.x,
      'y': instance.y,
      'maxBuildings': instance.maxBuildings,
      'status': _$ZoneStatusEnumMap[instance.status]!,
      'patches': instance.patches,
      'buildings': instance.buildings,
    };

const _$ZoneStatusEnumMap = {
  ZoneStatus.hidden: 'hidden',
  ZoneStatus.explored: 'explored',
};
