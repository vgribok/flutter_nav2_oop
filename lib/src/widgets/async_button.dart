part of flutter_nav2_oop;

Future<void> buttonAsyncOnPress(BuildContext context, StateController<bool> stateNotifier, {
  required String uiErrorMessage,
  String? logErrorMessage,
  Duration timeout = const Duration(seconds: 5),
  required Future<void> Function() onPressed,
  String busyUiMessage = 'Another operation is in progress, please wait'
}) async {

  final bool asyncActionInProgress = stateNotifier.state;
  if(asyncActionInProgress) {
    context.showSnackBar(busyUiMessage);
    return;
  }

  try {
    stateNotifier.state = true;
    await onPressed().timeout(timeout);
  } catch(e) {
    if(logErrorMessage != null) {
      '$logErrorMessage due to e'.debugPrint();
    }
    context.showSnackBar(uiErrorMessage);
  }
  finally
  {
    stateNotifier.state = false;
    assert(stateNotifier.state == false);
  }
}