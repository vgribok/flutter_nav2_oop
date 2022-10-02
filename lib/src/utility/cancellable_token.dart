part of flutter_nav2_oop;

/// Enables cancelling multiple cancellable operations at once,
/// and provides less error-prone pattern for using [CancelableOperation].
///
/// This class augments two flaws of the [CancelableOperation]:
/// 1. Ability to cancel multiple operations at once.
/// 2. Using correct method  - `valueOrCancellation()` - of the [CancelableOperation]
/// to access async result, ensuring cancellation works properly.
class CancellationToken {
  bool _isCancelled = false;

  final HashSet<CancelableOperation> _operations = HashSet();

  bool get isCancelled => _isCancelled;

  /// Cancels associated [Future] or [CancelableOperation].
  void cancel() {
    _isCancelled = true;

    // Use the copy of the set to prevent
    // operation's cancel() method from modifying
    // the collection that is being iterated.
    final opsCopy = HashSet.from(_operations);

    for (final CancelableOperation op in opsCopy) {
      op.cancel();
    }
  }

  /// Takes a [Future] and wraps it into the [CancelableOperation]
  /// before running the future. Cancellation of the returned
  /// Future is controlled by this class.
  ///
  /// We are taking Future callback as a parameter rather than Future instance
  /// because launching a Future before this call could be unnecessary. This
  /// approach ensures the factory won't be called if the operation was already
  /// cancelled. Avoid pre-launching Futures and passing them as `() => future`
  /// here. Pass the actual function launching a future for best cancellation
  /// behavior.
  Future<T?> run<T>(Future<T> Function() futureFactory) =>
      isCancelled ? Future.value(null) : runCancellable(CancelableOperation.fromFuture(futureFactory()));

  /// Takes and runs a [Future] already wrapped in the [CancelableOperation].
  Future<T?> runCancellable<T>(CancelableOperation<T> operation) async {
    if(isCancelled) {
      if(!operation.isCanceled) {
        operation.cancel();
      }
      return await operation.valueOrCancellation();
    }

    try {
      _operations.add(operation);
      return await operation.valueOrCancellation();
    }
    finally {
      _operations.remove(operation);
    }
  }
}

extension CancelableOperationEx<T> on CancelableOperation<T> {
  /// Adapts [CancelableOperation] for the use of a [CancellationToken]
  /// and returns awaitable [Future] that is cancellable with the token.
  Future<T?> withToken(CancellationToken? token) =>
      token == null ? valueOrCancellation() : token.runCancellable(this);
}