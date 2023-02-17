import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:tensionnode/extensions/json_location_extension.dart';
import 'package:tensionnode/json/json_connections.dart';
import 'package:tensionnode/types/resource_type.dart';

part 'json_flag.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonFlag {
  @JsonKey(name: 'location')
  final JsonLocation location;

  @JsonKey(name: 'queue')
  final List<ResourceType> queue;

  @JsonKey(name: 'connections')
  final JsonConnections connections;

  const JsonFlag({
    required this.location,
    required this.queue,
    required this.connections,
  });

  factory JsonFlag.fromString(String json) =>
      JsonFlag.fromJson(jsonDecode(json));

  factory JsonFlag.fromJson(Map<String, dynamic> json) =>
      _$JsonFlagFromJson(json);

  Map<String, dynamic> toJson() => _$JsonFlagToJson(this);
}
