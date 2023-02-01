// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_patch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonPatch _$JsonPatchFromJson(Map<String, dynamic> json) => JsonPatch(
      resource: $enumDecode(_$ResourceTypeEnumMap, json['resource']),
      position:
          (json['position'] as List<dynamic>).map((e) => e as int).toList(),
    );

Map<String, dynamic> _$JsonPatchToJson(JsonPatch instance) => <String, dynamic>{
      'resource': _$ResourceTypeEnumMap[instance.resource]!,
      'position': instance.position,
    };

const _$ResourceTypeEnumMap = {
  ResourceType.red: 'red',
  ResourceType.green: 'green',
  ResourceType.blue: 'blue',
};
