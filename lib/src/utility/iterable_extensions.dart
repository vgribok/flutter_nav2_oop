part of flutter_nav2_oop;

extension IterableExtensions<E> on Iterable<E> {

  /// Returns first item matching
  /// given criterion, or null if item was not found.
  E? firstSafe(bool test(E element)) {
    for(var e in this)
      if(test(e))
        return e;

    return null;
  }
}