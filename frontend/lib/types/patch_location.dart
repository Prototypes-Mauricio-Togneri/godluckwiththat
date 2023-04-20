import 'package:flutter/painting.dart';

enum PatchLocation {
  north,
  south,
  west,
  east;

  Offset get offset {
    switch (this) {
      case PatchLocation.north:
        return const Offset(0.5, 0.16);
      case PatchLocation.south:
        return const Offset(0.5, 0.85);
      case PatchLocation.west:
        return const Offset(0.16, 0.5);
      case PatchLocation.east:
        return const Offset(0.82, 0.5);
    }
  }
}
