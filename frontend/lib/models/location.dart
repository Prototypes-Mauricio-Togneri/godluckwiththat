import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/extensions/json_location_extension.dart';

typedef Locations = List<Location>;

class Location {
  final int i;
  final int j;

  const Location(this.i, this.j);

  factory Location.fromPosition(Vector2 position) => Location(
        position.x ~/ Constants.NODE_SIZE,
        position.y ~/ Constants.NODE_SIZE,
      );

  static Locations fromList(List<JsonLocation> json) =>
      json.map((e) => e.location).toList();

  JsonLocation get json => [i, j];

  bool isAligned(Location location) =>
      ((location.i == i) && (location.j != j)) ||
      ((location.j == j) && (location.i != i));

  double distanceTo(Location location) =>
      sqrt(pow(location.i - i, 2) + pow(location.j - j, 2));

  Vector2 get position => Vector2(
        i * Constants.NODE_SIZE,
        j * Constants.NODE_SIZE,
      );

  @override
  bool operator ==(Object other) =>
      other is Location &&
      other.runtimeType == runtimeType &&
      other.i == i &&
      other.j == j;

  @override
  int get hashCode => i.hashCode + j.hashCode;

  @override
  String toString() => '[$i, $j]';
}
