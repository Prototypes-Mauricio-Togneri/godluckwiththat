typedef ItemMap<T> = Map<T, double>;

extension ItemMapExtension<T> on ItemMap<T> {
  bool contains(T type) => keys.contains(type);

  double get(T type) => this[type] ?? 0;

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