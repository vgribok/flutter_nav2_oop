
import 'package:flutter/material.dart';

class Tuple {
  @protected
  final List<Object?> items;

  Tuple(this.items);

  Object? operator[](int? index) => getAt<Object?>(index);

  T? getAt<T>(int? index) =>
    index == null || index < 0 || index >= items.length ? null :
      items[index] as T?;

  MapEntry<K, V>? asKvPair<K,V>() =>
      items.length != 2 ? null : MapEntry(getAt<K>(0)!, getAt<V>(1)!);
}