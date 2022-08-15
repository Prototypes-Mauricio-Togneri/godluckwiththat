// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_lane.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonLane _$JsonLaneFromJson(Map<String, dynamic> json) => JsonLane(
      from: (json['from'] as List<dynamic>).map((e) => e as int).toList(),
      to: (json['to'] as List<dynamic>).map((e) => e as int).toList(),
    );

Map<String, dynamic> _$JsonLaneToJson(JsonLane instance) => <String, dynamic>{
      'from': instance.from,
      'to': instance.to,
    };
