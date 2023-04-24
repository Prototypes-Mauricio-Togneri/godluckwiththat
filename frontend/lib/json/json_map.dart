import 'dart:convert';
import 'package:gatewayguardians/json/json_map_zone.dart';
import 'package:json_annotation/json_annotation.dart';

part 'json_map.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonMap {
  @JsonKey(name: 'path')
  final String path;

  @JsonKey(name: 'width')
  final int width;

  @JsonKey(name: 'height')
  final int height;

  @JsonKey(name: 'zones')
  final List<JsonMapZone> zones;

  const JsonMap({
    required this.path,
    required this.width,
    required this.height,
    required this.zones,
  });

  factory JsonMap.fromString(String json) => JsonMap.fromJson(jsonDecode(json));

  factory JsonMap.fromJson(Map<String, dynamic> json) =>
      _$JsonMapFromJson(json);

  Map<String, dynamic> toJson() => _$JsonMapToJson(this);

  String toJsonString() => jsonEncode(toJson());
}
