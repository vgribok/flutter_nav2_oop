part of flutter_nav2_oop;

extension IterableExtensions<E> on Iterable<E> {

  /// Returns first item matching
  /// given criterion, or null if item was not found.
  E? firstSafe(bool Function(E element)? test) {
    for(var e in this) {
      if (test == null || test(e)) {
        return e;
      }
    }

    return null;
  }

  /// Converts [Iterable] to a [Map]
  Map<K,V> toMap<K,V>(K Function(E element) keyGetter, V Function(E element) valueGetter) =>
      { for (E e in this) keyGetter(e) : valueGetter(e) };

  bool all(bool Function(E item) test) {
    for(final E element in this) {
      if(!test(element)) return false;
    }

    return true;
  }

  bool containsAny(List<E> list) => any((element) => list.contains(element));

  bool containsAll(List<E> list) => all((element) => list.contains(element));
}

extension StreamExtensions<E> on Stream<E> {

  /// Returns first item matching
  /// given criterion, or null if item was not found.
  Future<E?> firstSafe(bool Function(E element)? test) async {
    test ??= (e) => true;
    final Stream filteredStream = where(test);
    return await filteredStream.isEmpty ? null : await filteredStream.first;
  }
}

extension MapEx<K,V> on Map<K,V> {
  List<MapEntry<K,V>> sort([int Function(MapEntry<K,V>, MapEntry<K,V>)? compare]) =>
     entries.toList()..sort(compare);

  List<MapEntry<K,V>> sortByKey(int Function(K, K) compare) =>
      sort((e1, e2) => compare(e1.key, e2.key));

  bool containsAnyKey(Iterable<K> collection) =>
      collection.any((element) => containsKey(element));

  bool containsAllKeys(Iterable<K> collection) =>
      collection.all((element) => containsKey(element));
}