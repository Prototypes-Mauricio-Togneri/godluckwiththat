extension NumExtension on num {
  num decimal() => num.parse(toStringAsFixed(2));
}
