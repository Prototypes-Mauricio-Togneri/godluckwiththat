// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_buildings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonBuildings _$JsonBuildingsFromJson(Map<String, dynamic> json) =>
    JsonBuildings(
      coalMines: (json['coal_mines'] as List<dynamic>)
          .map((e) => JsonBuilding.fromJson(e as Map<String, dynamic>))
          .toList(),
      copperMines: (json['copper_mines'] as List<dynamic>)
          .map((e) => JsonBuilding.fromJson(e as Map<String, dynamic>))
          .toList(),
      copperSmelters: (json['copper_smelters'] as List<dynamic>)
          .map((e) => JsonBuilding.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$JsonBuildingsToJson(JsonBuildings instance) =>
    <String, dynamic>{
      'coal_mines': instance.coalMines,
      'copper_mines': instance.copperMines,
      'copper_smelters': instance.copperSmelters,
    };
