import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';

abstract class ConnectivityHelper {
  static final _connectivity = Connectivity();

  static Future<bool> isInternetOnline() async {
    final result = await _connectivity.checkConnectivity();
    if (result == ConnectivityResult.ethernet ||
        result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  static Stream<ConnectivityResult> get connectivityStatus async* {
    yield* _connectivity.onConnectivityChanged;
  }

}
