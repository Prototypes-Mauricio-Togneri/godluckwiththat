import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:tensionnode/json/json_position.dart';

part 'json_lane.g.dart';

@JsonSerializable()
class JsonLane {
  @JsonKey(name: 'from')
  final JsonPosition from;

  @JsonKey(name: 'to')
  final JsonPosition to;

  const JsonLane({
    required this.from,
    required this.to,
  });

  factory JsonLane.fromString(String json) => JsonLane.fromJson(jsonDecode(json));

  factory JsonLane.fromJson(Map<String, dynamic> json) => _$JsonLaneFromJson(json);

  Map<String, dynamic> toJson() => _$JsonLaneToJson(this);
}
