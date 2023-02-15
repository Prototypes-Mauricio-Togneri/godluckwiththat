// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_woodcutter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonWoodcutter _$JsonWoodcutterFromJson(Map<String, dynamic> json) =>
    JsonWoodcutter(
      location:
          (json['location'] as List<dynamic>).map((e) => e as int).toList(),
      resource: $enumDecodeNullable(_$ResourceTypeEnumMap, json['resource']),
    );

Map<String, dynamic> _$JsonWoodcutterToJson(JsonWoodcutter instance) {
  final val = <String, dynamic>{
    'location': instance.location,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('resource', _$ResourceTypeEnumMap[instance.resource]);
  return val;
}

const _$ResourceTypeEnumMap = {
  ResourceType.timber: 'timber',
  ResourceType.stone: 'stone',
  ResourceType.wood: 'wood',
};
