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
      patches: JsonPatches.fromJson(json['patches'] as Map<String, dynamic>),
      headquarters: JsonHeadquarters.fromJson(
          json['headquarters'] as Map<String, dynamic>),
      buildings: (json['buildings'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            $enumDecode(_$NodeTypeEnumMap, k),
            (e as List<dynamic>)
                .map((e) => JsonBuilding.fromJson(e as Map<String, dynamic>))
                .toList()),
      ),
    );

Map<String, dynamic> _$JsonMatchToJson(JsonMatch instance) => <String, dynamic>{
      'version': instance.version,
      'id': instance.id,
      'totalTimeElapsed': instance.totalTimeElapsed,
      'map': instance.map,
      'patches': instance.patches,
      'headquarters': instance.headquarters,
      'buildings':
          instance.buildings.map((k, e) => MapEntry(_$NodeTypeEnumMap[k]!, e)),
    };

const _$NodeTypeEnumMap = {
  NodeType.headquarters: 'headquarters',
  NodeType.wind_turbine: 'wind_turbine',
  NodeType.solar_panel: 'solar_panel',
  NodeType.coal_power_plant: 'coal_power_plant',
  NodeType.oil_power_plant: 'oil_power_plant',
  NodeType.nuclear_power_plant: 'nuclear_power_plant',
  NodeType.iron_mine: 'iron_mine',
  NodeType.copper_mine: 'copper_mine',
  NodeType.stone_mine: 'stone_mine',
  NodeType.water_pump: 'water_pump',
  NodeType.coal_mine: 'coal_mine',
  NodeType.oil_rig: 'oil_rig',
  NodeType.titanium_mine: 'titanium_mine',
  NodeType.uranium_mine: 'uranium_mine',
  NodeType.iron_smelter: 'iron_smelter',
  NodeType.copper_smelter: 'copper_smelter',
  NodeType.stone_smelter: 'stone_smelter',
  NodeType.steel_smelter: 'steel_smelter',
  NodeType.polymer_plant: 'polymer_plant',
  NodeType.chemical_plant: 'chemical_plant',
  NodeType.oil_refinery: 'oil_refinery',
  NodeType.titanium_smelter: 'titanium_smelter',
  NodeType.gear_assembly: 'gear_assembly',
  NodeType.wire_assembly: 'wire_assembly',
  NodeType.transistor_assembly: 'transistor_assembly',
  NodeType.motor_assembly: 'motor_assembly',
  NodeType.chip_assembly: 'chip_assembly',
  NodeType.battery_assembly: 'battery_assembly',
  NodeType.circuit_assembly: 'circuit_assembly',
  NodeType.explosives_assembly: 'explosives_assembly',
  NodeType.drone_factory: 'drone_factory',
  NodeType.warehouse: 'warehouse',
};
