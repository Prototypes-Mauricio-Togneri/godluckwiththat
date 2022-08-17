// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_connection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonConnection _$JsonConnectionFromJson(Map<String, dynamic> json) => JsonConnection(
      from: (json['from'] as List<dynamic>).map((e) => e as int).toList(),
      to: (json['to'] as List<dynamic>).map((e) => e as int).toList(),
    );

Map<String, dynamic> _$JsonConnectionToJson(JsonConnection instance) => <String, dynamic>{
      'from': instance.from,
      'to': instance.to,
    };
