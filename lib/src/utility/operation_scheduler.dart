part of flutter_nav2_oop;

/// Scheduled a delayed operation.
/// Cancels previous operation if one was scheduled and has not run yet.
class CancellableScheduledOperation {
  void Function()? _operation;
  Future? _timerFuture;
  Function(CancellableScheduledOperation, bool)? _onFinish;

  void onTimerTick(Future myFuture) {
    debugPrint("Tick arrived for operation ${myFuture.hashCode}");
    if(myFuture != _timerFuture) {
      debugPrint("Ignoring cancelled future ${myFuture.hashCode}");
      return;
    }
    bool success = false;
    if(_operation != null) {
      debugPrint("Attempting scheduled operation ${myFuture.hashCode}");
      try {
        _operation!();
      }catch(e) {
        debugPrint("Scheduled operation ${myFuture.hashCode} has thrown an exception \"$e\"");
      }
      success = true;
    }

    if(_onFinish != null) {
      _onFinish!(this, success);
    }
    cancelOperation();
  }

  bool get isBusy => _operation != null;
  bool get isFree => !isBusy;

  void cancelOperation() {
    _operation = null;
    _timerFuture = null;
    _onFinish = null;
  }

  void delayOperation(
      Duration delay,
      void Function()? operation,
      {void Function(CancellableScheduledOperation, bool)? onFinish}
  ) {
    final future = Future.delayed(delay);
    debugPrint("Delaying operation ${future.hashCode} by $delay");
    scheduleOperation(future, operation, onFinish: onFinish);
  }

  void scheduleOperation(
      Future? future,
      void Function()? operationAfterFuture,
      {void Function(CancellableScheduledOperation, bool)? onFinish}
      ) {
    cancelOperation();

    if(onFinish != null && operationAfterFuture == null) {
      debugPrint("Can't use onFinish() if operation is empty");
      return;
    }

    if(operationAfterFuture == null) return;
    _operation = operationAfterFuture;
    _onFinish = onFinish;
    _timerFuture = future;
    debugPrint("Scheduling operation ${_timerFuture.hashCode}");
    _timerFuture!.then((value) => onTimerTick(future!));
  }
}