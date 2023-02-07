import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'json_mode.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonMode {
  @JsonKey(name: 'mode')
  final String mode;

  const JsonMode({
    required this.mode,
  });

  factory JsonMode.fromString(String json) =>
      JsonMode.fromJson(jsonDecode(json));

  factory JsonMode.fromJson(Map<String, dynamic> json) =>
      _$JsonModeFromJson(json);

  Map<String, dynamic> toJson() => _$JsonModeToJson(this);

  String toJsonString() => jsonEncode(toJson());
}
