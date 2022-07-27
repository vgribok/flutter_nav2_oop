part of flutter_nav2_oop;

abstract class Disposable {
  void close();
  bool _disposed = false;

  Disposable();

  // factory Disposable.call(void Function() closeFunc) =>
  //     DisposableThing(closeFunc);

  T disposeAfter<T>(T Function() func) {
    if(_disposed) {
      throw Exception("The object is already disposed");
    }

    try {
      return func();
    }
    finally {
      close();
      _disposed = true;
    }
  }

  /// Fluent version of the[disposeAfter]()
  T after<T>(T Function() func) => disposeAfter(func);

  bool get isDisposed => _disposed;
}

class DisposableThing extends Disposable {
  final void Function() closeFunc;

  DisposableThing(this.closeFunc);

  @override
  void close() => closeFunc();
}
