class MapList<K, V> {
  final Map<K, List<V>> _data = {};

  bool has(K key) => _data.containsKey(key);

  List<K> get keys => _data.keys.toList();

  void delete(K key) => _data.remove(key);

  void set(K key, List<V> value) {
    _data[key] = value;
  }

  void add(K key, V value) {
    if (_data.containsKey(key)) {
      _data[key]!.add(value);
    } else {
      _data[key] = [value];
    }
  }

  void remove(K key, V value) {
    if (_data.containsKey(key)) {
      _data[key]!.remove(value);

      if (_data[key]!.isEmpty) {
        _data.remove(key);
      }
    }
  }

  List<V> get(K key) {
    if (_data.containsKey(key)) {
      return _data[key]!;
    } else {
      return [];
    }
  }
}
