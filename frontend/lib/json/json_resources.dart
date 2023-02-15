import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:tensionnode/models/resources.dart';

part 'json_resources.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonResources {
  @JsonKey(name: 'timber')
  final int timber;

  @JsonKey(name: 'stone')
  final int stone;

  @JsonKey(name: 'wood')
  final int wood;

  const JsonResources({
    required this.timber,
    required this.stone,
    required this.wood,
  });

  Resources get resources => Resources(
        timber: timber,
        stone: stone,
        wood: wood,
      );

  factory JsonResources.fromString(String json) =>
      JsonResources.fromJson(jsonDecode(json));

  factory JsonResources.fromJson(Map<String, dynamic> json) =>
      _$JsonResourcesFromJson(json);

  Map<String, dynamic> toJson() => _$JsonResourcesToJson(this);
}
