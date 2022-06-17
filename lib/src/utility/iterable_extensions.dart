part of flutter_nav2_oop;

extension IterableExtensions<E> on Iterable<E> {

  /// Returns first item matching
  /// given criterion, or null if item was not found.
  E? firstSafe(bool Function(E element) test) {
    for(var e in this) {
      if (test(e)) {
        return e;
      }
    }

    return null;
  }

  /// Converts [Iterable] to a [Map]
  Map<K,V> toMap<K,V>(K Function(E element) keyGetter, V Function(E element) valueGetter) =>
      { for (E e in this) keyGetter(e) : valueGetter(e) };
}