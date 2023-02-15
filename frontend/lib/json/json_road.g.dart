// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_road.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonRoad _$JsonRoadFromJson(Map<String, dynamic> json) => JsonRoad(
      locationA:
          (json['locationA'] as List<dynamic>).map((e) => e as int).toList(),
      locationB:
          (json['locationB'] as List<dynamic>).map((e) => e as int).toList(),
    );

Map<String, dynamic> _$JsonRoadToJson(JsonRoad instance) => <String, dynamic>{
      'locationA': instance.locationA,
      'locationB': instance.locationB,
    };
