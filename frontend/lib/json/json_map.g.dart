// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_map.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonMap _$JsonMapFromJson(Map<String, dynamic> json) => JsonMap(
      name: json['name'] as String,
      xml: json['xml'] as String,
      location:
          (json['location'] as List<dynamic>).map((e) => e as int).toList(),
      zoom: json['zoom'] as num,
    );

Map<String, dynamic> _$JsonMapToJson(JsonMap instance) => <String, dynamic>{
      'name': instance.name,
      'xml': instance.xml,
      'location': instance.location,
      'zoom': instance.zoom,
    };
