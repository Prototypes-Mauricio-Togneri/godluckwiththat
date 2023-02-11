import 'dart:math';

extension ListExtension<T> on List<T> {
  T get random {
    final int index = Random().nextInt(length);

    return this[index];
  }
}
