import 'dart:math';

extension RandomExtension on Random {
  int between(int min, int max) => min + nextInt(max - min);
}
