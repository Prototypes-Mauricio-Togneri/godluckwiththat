import 'dart:convert';
import 'package:flame/game.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tensionnode/extensions/json_location_extension.dart';
import 'package:tensionnode/extensions/num_extension.dart';

part 'json_map.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonMap {
  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'xml')
  final String xml;

  @JsonKey(name: 'location')
  final JsonLocation location;

  @JsonKey(name: 'zoom')
  final num zoom;

  const JsonMap({
    required this.name,
    required this.xml,
    required this.location,
    required this.zoom,
  });

  JsonMap withCamera(Camera camera) => JsonMap(
        name: name,
        xml: xml,
        location: JsonLocationExtension.fromPosition(camera.absoluteTarget()),
        zoom: camera.zoom.decimal(),
      );

  factory JsonMap.fromString(String json) => JsonMap.fromJson(jsonDecode(json));

  factory JsonMap.fromJson(Map<String, dynamic> json) =>
      _$JsonMapFromJson(json);

  Map<String, dynamic> toJson() => _$JsonMapToJson(this);

  String toJsonString() => jsonEncode(toJson());
}
