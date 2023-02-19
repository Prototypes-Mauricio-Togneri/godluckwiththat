// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_quarry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonQuarry _$JsonQuarryFromJson(Map<String, dynamic> json) => JsonQuarry(
      location:
          (json['location'] as List<dynamic>).map((e) => e as int).toList(),
      connections:
          JsonConnections.fromJson(json['connections'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$JsonQuarryToJson(JsonQuarry instance) =>
    <String, dynamic>{
      'location': instance.location,
      'connections': instance.connections,
    };
