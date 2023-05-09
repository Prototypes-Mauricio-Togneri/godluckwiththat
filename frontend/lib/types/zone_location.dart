import 'package:flutter/painting.dart';

enum ZoneLocation {
  south,
  west,
  east;

  Offset get offset {
    switch (this) {
      case ZoneLocation.south:
        return const Offset(0, 0.4);
      case ZoneLocation.west:
        return const Offset(-0.4, -0.3);
      case ZoneLocation.east:
        return const Offset(0.4, -0.3);
    }
  }
}
