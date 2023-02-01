import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'json_resources.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonResources {
  @JsonKey(name: 'red')
  final num red;

  @JsonKey(name: 'green')
  final num green;

  @JsonKey(name: 'blue')
  final num blue;

  const JsonResources({
    required this.red,
    required this.green,
    required this.blue,
  });

  factory JsonResources.fromString(String json) =>
      JsonResources.fromJson(jsonDecode(json));

  factory JsonResources.fromJson(Map<String, dynamic> json) =>
      _$JsonResourcesFromJson(json);

  Map<String, dynamic> toJson() => _$JsonResourcesToJson(this);
}
