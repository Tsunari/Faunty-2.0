import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../firebase_options.dart';

/// Top-level background message handler required by `firebase_messaging`.
/// It must be a top-level or static function.
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Ensure Firebase is initialized in background isolate
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (kDebugMode) {
    print('Firebase Messaging background handler called. MessageId: ${message.messageId}');
    print('Message data: ${message.data}');
  }
  // Add any background processing logic here (e.g., update local DB via native plugins).
}

/// Simple, reusable NotificationService for initializing and listening to
/// Firebase Cloud Messaging across platforms (including web service worker).
///
/// Responsibilities:
/// - Initialize Firebase (if not already initialized)
/// - Request notification permissions
/// - Register background handler
/// - Expose a broadcast RemoteMessage Stream for UI to listen
/// - Provide helpers to get/delete the FCM token
class NotificationService {
  NotificationService._();

  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final StreamController<RemoteMessage> _messageStreamController =
      StreamController<RemoteMessage>.broadcast();
  static final StreamController<String> _tokenStreamController =
      StreamController<String>.broadcast();

  // Optional: keep your web VAPID public key here so callers don't need to pass it.
  // This should be the public VAPID key (base64) you configured in Firebase Console.
  // You can replace this value or load it from a secure config if you prefer.
  static const String vapidPublicKey =
      'BFAfGKzxnVVxMbYsIJ3NXS4L4iHjRdFh4MGJvP7qq6jyT78WOjhVthqzBKjejvIN6Um_QVKUA5gm6r2oVjs_63M';

  /// Stream of messages coming from foreground, opened-app and initial messages.
  static Stream<RemoteMessage> get messages => _messageStreamController.stream;

  /// Initialize the notification service. Call once early (for example in main()).
  ///
  /// This will:
  /// - initialize Firebase (using generated `DefaultFirebaseOptions`)
  /// - request notification permission
  /// - wire up onMessage, onMessageOpenedApp and background handler
  /// - fetch and print the FCM token
  /// [vapidKey] (optional) is the Web Push VAPID public key (base64) you
  /// configured in Firebase Console. If provided, it will be used when
  /// calling `getToken()` on web to ensure a push subscription is created.
  static Future<void> init({bool requestPermissions = true, String? vapidKey}) async {
    // Initialize Firebase if it's not initialized yet
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      }
    } catch (e) {
      if (kDebugMode) print('Firebase initialization error: $e');
    }

    // Register the background handler (required on Android/iOS)
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Optionally request permission (iOS & web require explicit permission)
    if (requestPermissions) {
      try {
        final settings = await _messaging.requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true,
        );
        if (kDebugMode) print('Notification permission: ${settings.authorizationStatus}');
      } catch (e) {
        if (kDebugMode) print('Error while requesting notification permission: $e');
      }
    }

    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('onMessage: ${message.messageId}');
        print('  data: ${message.data}');
        if (message.notification != null) {
          print('  notification: ${message.notification!.title} | ${message.notification!.body}');
        }
      }
      _messageStreamController.add(message);
    });

    // When a user taps a notification and opens the app
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) print('onMessageOpenedApp: ${message.messageId}');
      _messageStreamController.add(message);
    });

    // If the app was opened from a terminated state via a notification
    try {
      final initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null) {
        if (kDebugMode) print('getInitialMessage: ${initialMessage.messageId}');
        _messageStreamController.add(initialMessage);
      }
    } catch (e) {
      if (kDebugMode) print('Error getting initial message: $e');
    }

    // Listen for token refreshes and forward them to the token stream.
    _messaging.onTokenRefresh.listen((newToken) {
      if (kDebugMode) print('FCM token refreshed: $newToken');
      _tokenStreamController.add(newToken);
      // TODO: send newToken to your backend to update stored token for the user
      // sendTokenToServer(newToken);
    });

    // Print current FCM token (useful for debugging / sending test messages).
    // Use vapidKey if provided (web) to ensure proper subscription.
    try {
      final effectiveVapid = vapidKey ?? vapidPublicKey;
      final token = await _messaging.getToken(vapidKey: effectiveVapid);
      if (kDebugMode) print('FCM token: $token');
      if (token != null) {
        _tokenStreamController.add(token);
        // Optionally send the token to your backend here.
        // sendTokenToServer(token);
      }
    } catch (e) {
      if (kDebugMode) print('Error getting FCM token: $e');
    }
  }

  /// Returns the current FCM token for this device/browser (if available).
  /// Get the current FCM token. On web pass the optional [vapidKey] you set
  /// in Firebase Console (public key, base64). Returns null if no token.
  static Future<String?> getToken({String? vapidKey}) =>
      _messaging.getToken(vapidKey: vapidKey ?? vapidPublicKey);

  /// Deletes the current token (e.g., on sign-out).
  static Future<void> deleteToken() => _messaging.deleteToken();

  /// Stream of current/updated tokens. Useful to persist tokens server-side.
  static Stream<String> get tokenStream => _tokenStreamController.stream;

  /// Dispose internal controllers. Call when app is shutting down (optional).
  static void dispose() {
    try {
      if (!_messageStreamController.isClosed) _messageStreamController.close();
  if (!_tokenStreamController.isClosed) _tokenStreamController.close();
    } catch (_) {}
  }
}

/// Usage example (call from your main.dart after Firebase initialization):
///
/// await NotificationService.init();
/// NotificationService.messages.listen((message) { /* update UI */ });
/// final token = await NotificationService.getToken();
///
/// Note: For web background notifications you also need the `web/firebase-messaging-sw.js`
/// file placed in your `web/` directory (service worker). You already added that file.
