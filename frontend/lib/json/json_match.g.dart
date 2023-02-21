// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_match.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonMatch _$JsonMatchFromJson(Map<String, dynamic> json) => JsonMatch(
      version: json['version'] as int,
      id: json['id'] as String,
      totalTimeElapsed: json['totalTimeElapsed'] as num,
      map: JsonMap.fromJson(json['map'] as Map<String, dynamic>),
      headquarters: JsonHeadquarters.fromJson(
          json['headquarters'] as Map<String, dynamic>),
      woodcutters: (json['woodcutters'] as List<dynamic>)
          .map((e) => JsonProducer.fromJson(e as Map<String, dynamic>))
          .toList(),
      quarries: (json['quarries'] as List<dynamic>)
          .map((e) => JsonProducer.fromJson(e as Map<String, dynamic>))
          .toList(),
      wells: (json['wells'] as List<dynamic>)
          .map((e) => JsonProducer.fromJson(e as Map<String, dynamic>))
          .toList(),
      fishers: (json['fishers'] as List<dynamic>)
          .map((e) => JsonProducer.fromJson(e as Map<String, dynamic>))
          .toList(),
      hunters: (json['hunters'] as List<dynamic>)
          .map((e) => JsonProducer.fromJson(e as Map<String, dynamic>))
          .toList(),
      cropFarms: (json['cropFarms'] as List<dynamic>)
          .map((e) => JsonProducer.fromJson(e as Map<String, dynamic>))
          .toList(),
      saweries: (json['saweries'] as List<dynamic>)
          .map((e) => JsonTransformer.fromJson(e as Map<String, dynamic>))
          .toList(),
      mills: (json['mills'] as List<dynamic>)
          .map((e) => JsonTransformer.fromJson(e as Map<String, dynamic>))
          .toList(),
      bakeries: (json['bakeries'] as List<dynamic>)
          .map((e) => JsonTransformer.fromJson(e as Map<String, dynamic>))
          .toList(),
      flags: (json['flags'] as List<dynamic>)
          .map((e) => JsonFlag.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$JsonMatchToJson(JsonMatch instance) => <String, dynamic>{
      'version': instance.version,
      'id': instance.id,
      'totalTimeElapsed': instance.totalTimeElapsed,
      'map': instance.map,
      'headquarters': instance.headquarters,
      'woodcutters': instance.woodcutters,
      'quarries': instance.quarries,
      'wells': instance.wells,
      'fishers': instance.fishers,
      'hunters': instance.hunters,
      'cropFarms': instance.cropFarms,
      'saweries': instance.saweries,
      'mills': instance.mills,
      'bakeries': instance.bakeries,
      'flags': instance.flags,
    };
