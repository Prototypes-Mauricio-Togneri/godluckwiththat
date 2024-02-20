import 'dart:math';
import 'package:godluckwiththat/extensions/item_map_extension.dart';

class BaseInventory<K> {
  final ItemMap<K> _stockpile;
  final ItemMap<K> _capacities;

  BaseInventory(this._stockpile, this._capacities);

  bool get isEmpty {
    for (final ItemMapEntry<K> item in _stockpile.entries) {
      if (item.value != 0) {
        return false;
      }
    }

    return true;
  }

  num capacityOf(K type) => _capacities.get(type);

  num get(K type) => _stockpile.get(type);

  void add(K type, num amount) {
    final num current = get(type);
    final num capacity = capacityOf(type);
    _stockpile[type] = min(current + amount, capacity);
  }

  void remove(K type, num amount) {
    final num current = get(type);
    _stockpile[type] = current - amount;
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

  void addInventory(BaseInventory<K> inventory) =>
      addItems(inventory._stockpile);

  void removeInventory(BaseInventory<K> inventory) =>
      removeItems(inventory._stockpile);

  bool hasType(K type) => _stockpile[type] != null;

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
