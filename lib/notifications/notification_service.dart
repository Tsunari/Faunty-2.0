import 'dart:io' show Platform;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'token_management.dart';

/// Simple NotificationService wrapper for FCM initialization and handling.
class NotificationService {
	NotificationService._();

	static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

	/// Initialize FCM. If [requestPermissions] is true, will request permissions on iOS/web.
	static Future<void> init({bool requestPermissions = true}) async {
				// On web, enable auto init and we'll pass the VAPID key to getToken below
				if (kIsWeb) {
					try {
						await _messaging.getInitialMessage();
						await _messaging.setAutoInitEnabled(true);
					} catch (e) {
						if (kDebugMode) print('Web FCM init warning: $e');
					}
				}

		// Get and handle token
		_messaging.onTokenRefresh.listen((newToken) async {
			await _storeTokenIfAvailable(newToken);
		});

			String? currentToken;
			if (kIsWeb) {
				const vapidKey = 'BFAfGKzxnVVxMbYsIJ3NXS4L4iHjRdFh4MGJvP7qq6jyT78WOjhVthqzBKjejvIN6Um_QVKUA5gm6r2oVjs_63M';
				try {
					currentToken = await _messaging.getToken(vapidKey: vapidKey);
				} catch (e) {
					if (kDebugMode) print('getToken with vapidKey failed: $e');
					currentToken = await _messaging.getToken();
				}
			} else {
				currentToken = await _messaging.getToken();
			}
			if (currentToken != null) {
				await _storeTokenIfAvailable(currentToken);
			}

		// Request permissions where relevant
		if (requestPermissions) {
			NotificationSettings settings = await _messaging.requestPermission(
				alert: true,
				badge: true,
				sound: true,
			);
			if (kDebugMode) {
				print('FCM permission status: ${settings.authorizationStatus}');
			}
		}

		// Optional: foreground message handler
		FirebaseMessaging.onMessage.listen((RemoteMessage msg) {
			if (kDebugMode) print('Foreground message received: ${msg.messageId}');
			// app-specific handling can be added by listening to this stream where needed
		});
	}

	/// Check permission & optionally request it.
	static Future<NotificationSettings> checkAndRequestPermission({bool requestIfNot = true}) async {
		final settings = await _messaging.getNotificationSettings();
		if (settings.authorizationStatus == AuthorizationStatus.notDetermined && requestIfNot) {
			return await _messaging.requestPermission(alert: true, badge: true, sound: true);
		}
		return settings;
	}

	static Future<void> _storeTokenIfAvailable(String token) async {
		// Get current user UID if available
		final uid = FirebaseAuth.instance.currentUser?.uid;
		final platform = _detectPlatform();
		final now = DateTime.now().toUtc();

		final tokenInfo = TokenInfo(
			token: token,
			uid: uid,
			platform: platform,
			createdAt: now,
			lastSeenAt: now,
		);

		await TokenManager.saveToken(tokenInfo);
	}

	static String _detectPlatform() {
		if (kIsWeb) return 'web';
		if (Platform.isAndroid) return 'android';
		if (Platform.isIOS) return 'ios';
		if (Platform.isMacOS) return 'macos';
		if (Platform.isWindows) return 'windows';
		if (Platform.isLinux) return 'linux';
		return 'unknown';
	}
}
