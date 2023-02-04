import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:tensionnode/extensions/json_position_extension.dart';

part 'json_hole.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonHole {
  @JsonKey(name: 'position')
  final JsonPosition position;

  const JsonHole({
    required this.position,
  });

  factory JsonHole.fromString(String json) =>
      JsonHole.fromJson(jsonDecode(json));

  factory JsonHole.fromJson(Map<String, dynamic> json) =>
      _$JsonHoleFromJson(json);

  Map<String, dynamic> toJson() => _$JsonHoleToJson(this);
}
