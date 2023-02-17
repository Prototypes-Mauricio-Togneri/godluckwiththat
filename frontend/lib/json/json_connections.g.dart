// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_connections.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonConnections _$JsonConnectionsFromJson(Map<String, dynamic> json) =>
    JsonConnections(
      north: (json['north'] as List<dynamic>?)?.map((e) => e as int).toList(),
      east: (json['east'] as List<dynamic>?)?.map((e) => e as int).toList(),
      south: (json['south'] as List<dynamic>?)?.map((e) => e as int).toList(),
      west: (json['west'] as List<dynamic>?)?.map((e) => e as int).toList(),
    );

Map<String, dynamic> _$JsonConnectionsToJson(JsonConnections instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('north', instance.north);
  writeNotNull('east', instance.east);
  writeNotNull('south', instance.south);
  writeNotNull('west', instance.west);
  return val;
}
