// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_building.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonBuilding _$JsonBuildingFromJson(Map<String, dynamic> json) => JsonBuilding(
      location:
          (json['location'] as List<dynamic>).map((e) => e as int).toList(),
      inventory: (json['inventory'] as Map<String, dynamic>).map(
        (k, e) => MapEntry($enumDecode(_$ResourceTypeEnumMap, k), e as int),
      ),
      resourceType:
          $enumDecodeNullable(_$ResourceTypeEnumMap, json['resourceType']),
    );

Map<String, dynamic> _$JsonBuildingToJson(JsonBuilding instance) {
  final val = <String, dynamic>{
    'location': instance.location,
    'inventory': instance.inventory
        .map((k, e) => MapEntry(_$ResourceTypeEnumMap[k]!, e)),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('resourceType', _$ResourceTypeEnumMap[instance.resourceType]);
  return val;
}

const _$ResourceTypeEnumMap = {
  ResourceType.energy: 'energy',
  ResourceType.iron_ore: 'iron_ore',
  ResourceType.copper_ore: 'copper_ore',
  ResourceType.stone_ore: 'stone_ore',
  ResourceType.water: 'water',
  ResourceType.coal_ore: 'coal_ore',
  ResourceType.crude_oil: 'crude_oil',
  ResourceType.titanium_ore: 'titanium_ore',
  ResourceType.uranium_ore: 'uranium_ore',
  ResourceType.iron_plate: 'iron_plate',
  ResourceType.copper_plate: 'copper_plate',
  ResourceType.concrete: 'concrete',
  ResourceType.steel: 'steel',
  ResourceType.plastic: 'plastic',
  ResourceType.sulfur: 'sulfur',
  ResourceType.fuel: 'fuel',
  ResourceType.titanium_plate: 'titanium_plate',
  ResourceType.gear: 'gear',
  ResourceType.wire: 'wire',
  ResourceType.transistor: 'transistor',
  ResourceType.motor: 'motor',
  ResourceType.chip: 'chip',
  ResourceType.battery: 'battery',
  ResourceType.microprocessor: 'microprocessor',
  ResourceType.explosives: 'explosives',
  ResourceType.standard_shell: 'standard_shell',
  ResourceType.piercing_shell: 'piercing_shell',
  ResourceType.cannon_shell: 'cannon_shell',
  ResourceType.drone: 'drone',
  ResourceType.light_mech: 'light_mech',
  ResourceType.heavy_mech: 'heavy_mech',
  ResourceType.laser_mech: 'laser_mech',
  ResourceType.armored_mech: 'armored_mech',
  ResourceType.cannon_mech: 'cannon_mech',
  ResourceType.time: 'time',
};
