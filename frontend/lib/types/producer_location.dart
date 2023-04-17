import 'package:flutter/painting.dart';

enum ProducerLocation {
  north,
  south,
  west,
  east;

  Offset get offset {
    switch (this) {
      case ProducerLocation.north:
        return const Offset(0.5, 0.16);
      case ProducerLocation.south:
        return const Offset(0.5, 0.85);
      case ProducerLocation.west:
        return const Offset(0.16, 0.5);
      case ProducerLocation.east:
        return const Offset(0.82, 0.5);
    }
  }
}
