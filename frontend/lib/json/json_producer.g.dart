// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_producer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonProducer _$JsonProducerFromJson(Map<String, dynamic> json) => JsonProducer(
      location:
          (json['location'] as List<dynamic>).map((e) => e as int).toList(),
      connections: (json['connections'] as List<dynamic>)
          .map((e) => (e as List<dynamic>).map((e) => e as int).toList())
          .toList(),
    );

Map<String, dynamic> _$JsonProducerToJson(JsonProducer instance) =>
    <String, dynamic>{
      'location': instance.location,
      'connections': instance.connections,
    };
