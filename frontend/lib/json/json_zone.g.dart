// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_zone.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonZone _$JsonZoneFromJson(Map<String, dynamic> json) => JsonZone(
      patches: (json['patches'] as List<dynamic>)
          .map((e) => JsonPatch.fromJson(e as Map<String, dynamic>))
          .toList(),
      buildings: (json['buildings'] as List<dynamic>)
          .map((e) => JsonBuilding.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$JsonZoneToJson(JsonZone instance) => <String, dynamic>{
      'patches': instance.patches,
      'buildings': instance.buildings,
    };
