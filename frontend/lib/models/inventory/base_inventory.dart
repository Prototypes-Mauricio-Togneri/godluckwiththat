import 'package:godluckwiththat/extensions/item_map_extension.dart';

class BaseInventory<K> {
  final ItemMap<K> _items;

  BaseInventory(this._items);

  bool get isEmpty {
    for (final ItemMapEntry<K> item in _items.entries) {
      if (item.value != 0) {
        return false;
      }
    }

    return true;
  }

  num get(K type) => _items.get(type);

  void add(K type, num amount) {
    _items[type] = get(type) + amount;
  }

  void remove(K type, num amount) {
    final num current = get(type);
    _items[type] = current - amount;
  }

  void addItem(ItemMapEntry<K> item) => add(item.key, item.value);

  void removeItem(ItemMapEntry<K> item) => remove(item.key, item.value);

  void addItems(ItemMap<K> map) {
    for (final ItemMapEntry<K> item in map.entries) {
      add(item.key, item.value);
    }
  }

  void removeItems(ItemMap<K> map) {
    for (final ItemMapEntry<K> item in map.entries) {
      remove(item.key, item.value);
    }
  }

  void addInventory(BaseInventory<K> inventory) => addItems(inventory._items);

  void removeInventory(BaseInventory<K> inventory) =>
      removeItems(inventory._items);

  bool hasType(K type) => _items[type] != null;

  bool has(K type, num amount) => get(type) >= amount;

  bool hasItem(ItemMapEntry<K> item) => has(item.key, item.value);

  bool hasItems(ItemMap<K> map) {
    for (final ItemMapEntry<K> item in map.entries) {
      if (!hasItem(item)) {
        return false;
      }
    }

    return true;
  }
}
