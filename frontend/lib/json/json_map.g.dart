// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_map.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonMap _$JsonMapFromJson(Map<String, dynamic> json) => JsonMap(
      path: json['path'] as String,
      width: json['width'] as int,
      height: json['height'] as int,
      zones: (json['zones'] as List<dynamic>)
          .map((e) => JsonMapZone.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$JsonMapToJson(JsonMap instance) => <String, dynamic>{
      'path': instance.path,
      'width': instance.width,
      'height': instance.height,
      'zones': instance.zones,
    };
