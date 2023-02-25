// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_patch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonPatch _$JsonPatchFromJson(Map<String, dynamic> json) => JsonPatch(
      location:
          (json['location'] as List<dynamic>).map((e) => e as int).toList(),
      amount: json['amount'] as int,
    );

Map<String, dynamic> _$JsonPatchToJson(JsonPatch instance) => <String, dynamic>{
      'location': instance.location,
      'amount': instance.amount,
    };
