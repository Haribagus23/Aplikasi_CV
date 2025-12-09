import 'package:flutter/foundation.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class OneSignalService {
  // GANTI DENGAN APP ID ONESIGNAL ANDA
  static const String _oneSignalAppId = "b490451f-d4ec-4bf1-9567-62c07f8b9b59";

  static Future<void> initialize() async {
    if (_oneSignalAppId.isEmpty) {
      debugPrint(
        "⚠️ OneSignal App ID belum diset! Notifikasi tidak akan jalan.",
      );
      return;
    }

    try {
      // Remove this method to stop OneSignal Debugging
      OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

      OneSignal.initialize(_oneSignalAppId);

      // The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt.
      // We recommend removing the following code and instead using an In-App Message to prompt for notification permission
      OneSignal.Notifications.requestPermission(true);

      debugPrint("✅ OneSignal Initialized Successfully");
    } catch (e) {
      debugPrint("❌ Error initializing OneSignal: $e");
    }
  }

  static Future<void> login(String externalUserId) async {
    OneSignal.login(externalUserId);
  }

  static Future<void> logout() async {
    OneSignal.logout();
  }
}
