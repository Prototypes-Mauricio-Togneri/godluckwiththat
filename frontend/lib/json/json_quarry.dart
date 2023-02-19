import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:tensionnode/extensions/json_location_extension.dart';
import 'package:tensionnode/json/json_connections.dart';

part 'json_quarry.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonQuarry {
  @JsonKey(name: 'location')
  final JsonLocation location;

  @JsonKey(name: 'connections')
  final JsonConnections connections;

  const JsonQuarry({
    required this.location,
    required this.connections,
  });

  factory JsonQuarry.fromString(String json) =>
      JsonQuarry.fromJson(jsonDecode(json));

  factory JsonQuarry.fromJson(Map<String, dynamic> json) =>
      _$JsonQuarryFromJson(json);

  Map<String, dynamic> toJson() => _$JsonQuarryToJson(this);
}
