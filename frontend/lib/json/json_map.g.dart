// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_map.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonMap _$JsonMapFromJson(Map<String, dynamic> json) => JsonMap(
      name: json['name'] as String,
      xml: json['xml'] as String,
      position:
          (json['position'] as List<dynamic>).map((e) => e as num).toList(),
      zoom: json['zoom'] as num,
    );

Map<String, dynamic> _$JsonMapToJson(JsonMap instance) => <String, dynamic>{
      'name': instance.name,
      'xml': instance.xml,
      'position': instance.position,
      'zoom': instance.zoom,
    };
