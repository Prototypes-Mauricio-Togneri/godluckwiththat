import 'package:flutter/painting.dart';

enum ZoneLocation {
  north,
  south,
  west,
  east;

  Offset get offset {
    switch (this) {
      case ZoneLocation.north:
        return const Offset(0, -0.5);
      case ZoneLocation.south:
        return const Offset(0, 0.5);
      case ZoneLocation.west:
        return const Offset(-0.5, 0);
      case ZoneLocation.east:
        return const Offset(0.5, 0);
    }
  }
}
