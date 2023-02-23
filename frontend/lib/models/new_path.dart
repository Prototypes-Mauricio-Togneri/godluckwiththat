import 'package:tensionnode/models/location.dart';

class NewPath {
  final Location origin;
  final Location target;

  const NewPath(this.origin, this.target);

  bool get isAligned => origin.isAligned(target);

  Set<Location> get intermediateLocations {
    final Set<Location> result = {};

    if (origin.i == target.i) {
      if (origin.j > target.j) {
        for (int j = target.j; j <= origin.j; j++) {
          result.add(Location(origin.i, j));
        }
      } else {
        for (int j = origin.j; j <= target.j; j++) {
          result.add(Location(origin.i, j));
        }
      }
    } else if (origin.j == target.j) {
      if (origin.i > target.i) {
        for (int i = target.i; i <= origin.i; i++) {
          result.add(Location(i, origin.j));
        }
      } else {
        for (int i = origin.i; i <= target.i; i++) {
          result.add(Location(i, origin.j));
        }
      }
    } else {
      throw Exception(
          'Path extremes are not aligned. Origin: $origin. Target: $target');
    }

    return result;
  }
}
