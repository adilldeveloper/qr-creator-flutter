/*
import 'dart:io';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';

class AttService {
  static Future<void> requestIfNeeded() async {
    if (!Platform.isIOS) return;

    final status =
    await AppTrackingTransparency.trackingAuthorizationStatus;

    if (status == TrackingStatus.notDetermined) {
      await AppTrackingTransparency.requestTrackingAuthorization();
    }
  }
}


 */

