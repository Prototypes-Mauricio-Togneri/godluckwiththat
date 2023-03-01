// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_patches.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonPatches _$JsonPatchesFromJson(Map<String, dynamic> json) => JsonPatches(
      iron: (json['iron'] as List<dynamic>)
          .map((e) => JsonPatch.fromJson(e as Map<String, dynamic>))
          .toList(),
      copper: (json['copper'] as List<dynamic>)
          .map((e) => JsonPatch.fromJson(e as Map<String, dynamic>))
          .toList(),
      coal: (json['coal'] as List<dynamic>)
          .map((e) => JsonPatch.fromJson(e as Map<String, dynamic>))
          .toList(),
      stone: (json['stone'] as List<dynamic>)
          .map((e) => JsonPatch.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$JsonPatchesToJson(JsonPatches instance) =>
    <String, dynamic>{
      'iron': instance.iron,
      'copper': instance.copper,
      'coal': instance.coal,
      'stone': instance.stone,
    };
