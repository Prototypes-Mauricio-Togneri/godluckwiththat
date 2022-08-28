import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'json_map.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonMap {
  @JsonKey(name: 'number_of_blocks_horizontal')
  final int numberOfBlocksHorizontal;

  @JsonKey(name: 'number_of_blocks_vertical')
  final int numberOfBlocksVertical;

  @JsonKey(name: 'block_size')
  final int blockSize;

  const JsonMap({
    required this.numberOfBlocksHorizontal,
    required this.numberOfBlocksVertical,
    required this.blockSize,
  });

  factory JsonMap.fromString(String json) => JsonMap.fromJson(jsonDecode(json));

  factory JsonMap.fromJson(Map<String, dynamic> json) => _$JsonMapFromJson(json);

  Map<String, dynamic> toJson() => _$JsonMapToJson(this);
}
