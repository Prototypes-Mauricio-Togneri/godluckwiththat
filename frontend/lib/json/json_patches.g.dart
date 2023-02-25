// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_patches.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonPatches _$JsonPatchesFromJson(Map<String, dynamic> json) => JsonPatches(
      coal: (json['coal'] as List<dynamic>)
          .map((e) => JsonPatch.fromJson(e as Map<String, dynamic>))
          .toList(),
      cooper: (json['cooper'] as List<dynamic>)
          .map((e) => JsonPatch.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$JsonPatchesToJson(JsonPatches instance) =>
    <String, dynamic>{
      'coal': instance.coal,
      'cooper': instance.cooper,
    };
