part of flutter_nav2_oop;

Future<bool> checkInternetConnection({
    Duration maxWait = const Duration(seconds: 5),
    String domainToTryConnectingTo="aws.amazon.com"
}) async {
  try {
    final result = await InternetAddress.lookup(domainToTryConnectingTo).timeout(maxWait);
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }
  }
  on TimeoutException catch(_) {
  }
  on SocketException catch (_) {
  }

  return false;
}