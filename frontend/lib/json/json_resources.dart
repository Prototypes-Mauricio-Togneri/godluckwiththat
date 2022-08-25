import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'json_resources.g.dart';

@JsonSerializable()
class JsonResources {
  @JsonKey(name: 'resource1')
  final int resource1;

  @JsonKey(name: 'resource2')
  final int resource2;

  @JsonKey(name: 'resource3')
  final int resource3;

  const JsonResources({
    required this.resource1,
    required this.resource2,
    required this.resource3,
  });

  factory JsonResources.fromString(String json) => JsonResources.fromJson(jsonDecode(json));

  factory JsonResources.fromJson(Map<String, dynamic> json) => _$JsonResourcesFromJson(json);

  Map<String, dynamic> toJson() => _$JsonResourcesToJson(this);
}
