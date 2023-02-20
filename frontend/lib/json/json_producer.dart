import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:tensionnode/extensions/json_location_extension.dart';
import 'package:tensionnode/json/json_connections.dart';

part 'json_producer.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonProducer {
  @JsonKey(name: 'location')
  final JsonLocation location;

  @JsonKey(name: 'connections')
  final JsonConnections connections;

  const JsonProducer({
    required this.location,
    required this.connections,
  });

  factory JsonProducer.fromString(String json) =>
      JsonProducer.fromJson(jsonDecode(json));

  factory JsonProducer.fromJson(Map<String, dynamic> json) =>
      _$JsonProducerFromJson(json);

  Map<String, dynamic> toJson() => _$JsonProducerToJson(this);
}
