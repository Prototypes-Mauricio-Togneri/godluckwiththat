// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_lane.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonLane _$JsonLaneFromJson(Map<String, dynamic> json) => JsonLane(
      from: JsonPosition.fromJson(json['from'] as Map<String, dynamic>),
      to: JsonPosition.fromJson(json['to'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$JsonLaneToJson(JsonLane instance) => <String, dynamic>{
      'from': instance.from,
      'to': instance.to,
    };
