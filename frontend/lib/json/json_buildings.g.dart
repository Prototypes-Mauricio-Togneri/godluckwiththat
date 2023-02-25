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
      cooperMines: (json['cooper_mines'] as List<dynamic>)
          .map((e) => JsonBuilding.fromJson(e as Map<String, dynamic>))
          .toList(),
      cooperFurnaces: (json['cooper_furnaces'] as List<dynamic>)
          .map((e) => JsonBuilding.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$JsonBuildingsToJson(JsonBuildings instance) =>
    <String, dynamic>{
      'coal_mines': instance.coalMines,
      'cooper_mines': instance.cooperMines,
      'cooper_furnaces': instance.cooperFurnaces,
    };
