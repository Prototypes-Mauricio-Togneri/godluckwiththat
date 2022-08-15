// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_map.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonMap _$JsonMapFromJson(Map<String, dynamic> json) => JsonMap(
      numberOfBlocksHorizontal: json['number_of_blocks_horizontal'] as int,
      numberOfBlocksVertical: json['number_of_blocks_vertical'] as int,
      blockSize: json['block_size'] as int,
    );

Map<String, dynamic> _$JsonMapToJson(JsonMap instance) => <String, dynamic>{
      'number_of_blocks_horizontal': instance.numberOfBlocksHorizontal,
      'number_of_blocks_vertical': instance.numberOfBlocksVertical,
      'block_size': instance.blockSize,
    };
