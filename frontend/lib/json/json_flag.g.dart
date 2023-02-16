// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_flag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonFlag _$JsonFlagFromJson(Map<String, dynamic> json) => JsonFlag(
      location:
          (json['location'] as List<dynamic>).map((e) => e as int).toList(),
      inventory:
          JsonInventory.fromJson(json['inventory'] as Map<String, dynamic>),
      roadNorth:
          (json['roadNorth'] as List<dynamic>?)?.map((e) => e as int).toList(),
      roadEast:
          (json['roadEast'] as List<dynamic>?)?.map((e) => e as int).toList(),
      roadSouth:
          (json['roadSouth'] as List<dynamic>?)?.map((e) => e as int).toList(),
      roadWest:
          (json['roadWest'] as List<dynamic>?)?.map((e) => e as int).toList(),
    );

Map<String, dynamic> _$JsonFlagToJson(JsonFlag instance) {
  final val = <String, dynamic>{
    'location': instance.location,
    'inventory': instance.inventory,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('roadNorth', instance.roadNorth);
  writeNotNull('roadEast', instance.roadEast);
  writeNotNull('roadSouth', instance.roadSouth);
  writeNotNull('roadWest', instance.roadWest);
  return val;
}
