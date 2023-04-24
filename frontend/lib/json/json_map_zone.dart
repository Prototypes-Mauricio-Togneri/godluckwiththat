import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'json_map_zone.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonMapZone {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'x')
  final double x;

  @JsonKey(name: 'y')
  final double y;

  const JsonMapZone({
    required this.id,
    required this.x,
    required this.y,
  });

  factory JsonMapZone.fromString(String json) =>
      JsonMapZone.fromJson(jsonDecode(json));

  factory JsonMapZone.fromJson(Map<String, dynamic> json) =>
      _$JsonMapZoneFromJson(json);

  Map<String, dynamic> toJson() => _$JsonMapZoneToJson(this);

  String toJsonString() => jsonEncode(toJson());
}
