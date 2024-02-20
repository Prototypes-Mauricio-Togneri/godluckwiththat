typedef ItemMap<T> = Map<T, num>;

typedef ItemMapEntry<T> = MapEntry<T, num>;

extension ItemMapExtension<T> on ItemMap<T> {
  bool contains(T type) => keys.contains(type);

  num get(T type) => this[type] ?? 0;

  String join() {
    String result = '';

    for (final T type in keys) {
      if (result.isNotEmpty) {
        result += '\n';
      }

      result += '$type: ${get(type)}';
    }

    return result;
  }
}
