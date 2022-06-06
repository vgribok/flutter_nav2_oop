part of flutter_nav2_oop;

/// Scheduled a delayed operation.
/// Cancels previous operation if one was scheduled and has not run yet.
class CancellableDelayedOperation {
  void Function()? _operation;
  Future? _timerFuture;
  Function(CancellableDelayedOperation, bool)? _onFinish;

  void onTimerTick(Future myFuture) {
    debugPrint("Tick arrived for operation ${myFuture.hashCode}");
    if(myFuture != _timerFuture) {
      debugPrint("Ignoring cancelled future");
      return;
    }
    bool success = false;
    if(_operation != null) {
      debugPrint("Attempting scheduled operation");
      try {
        _operation!();
      }catch(e) {
        debugPrint("Scheduled operation has thrown an exception \"$e\"");
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

  void scheduleOperation(Duration delay, void Function()? operation,
      {void Function(CancellableDelayedOperation, bool)? onFinish}
      ) {
    cancelOperation();

    if(onFinish != null && operation == null) {
      debugPrint("Can't use onFinish() in operation is empty");
      return;
    }

    if(operation == null) return;
    _operation = operation;
    _onFinish = onFinish;
    _timerFuture = Future.delayed(delay);
    var myFuture = _timerFuture;
    debugPrint("Delaying operation ${myFuture.hashCode} by $delay");
    _timerFuture!.then((value) => onTimerTick(myFuture!));
  }
}