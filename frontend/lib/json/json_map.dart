import 'dart:convert';
import 'package:flame/game.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tensionnode/extensions/json_position_extension.dart';
import 'package:tensionnode/models/position.dart';

part 'json_map.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonMap {
  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'xml')
  final String xml;

  @JsonKey(name: 'position')
  final JsonPosition position;

  @JsonKey(name: 'zoom')
  final num zoom;

  const JsonMap({
    required this.name,
    required this.xml,
    required this.position,
    required this.zoom,
  });

  JsonMap withCamera(Camera camera) => JsonMap(
        name: name,
        xml: xml,
        position: Position.json(camera.absoluteTarget()),
        zoom: camera.zoom,
      );

  factory JsonMap.fromString(String json) => JsonMap.fromJson(jsonDecode(json));

  factory JsonMap.fromJson(Map<String, dynamic> json) =>
      _$JsonMapFromJson(json);

  Map<String, dynamic> toJson() => _$JsonMapToJson(this);

  String toJsonString() => jsonEncode(toJson());
}
