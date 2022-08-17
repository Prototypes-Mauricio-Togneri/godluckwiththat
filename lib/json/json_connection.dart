import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:tensionnode/extensions/json_position_extension.dart';

part 'json_connection.g.dart';

@JsonSerializable()
class JsonConnection {
  @JsonKey(name: 'from')
  final JsonPosition from;

  @JsonKey(name: 'to')
  final JsonPosition to;

  const JsonConnection({
    required this.from,
    required this.to,
  });

  factory JsonConnection.fromString(String json) => JsonConnection.fromJson(jsonDecode(json));

  factory JsonConnection.fromJson(Map<String, dynamic> json) => _$JsonConnectionFromJson(json);

  Map<String, dynamic> toJson() => _$JsonConnectionToJson(this);
}
