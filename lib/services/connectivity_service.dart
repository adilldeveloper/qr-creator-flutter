import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  static Future<bool> hasInternet() async {
    // Step 1: Check if any network is available
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      return false;
    }

    // Step 2: Verify real internet access (DNS lookup)
    try {
      final result = await InternetAddress.lookup('example.com')
          .timeout(const Duration(seconds: 5));

      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}
