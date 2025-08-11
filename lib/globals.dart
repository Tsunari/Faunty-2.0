import 'package:faunty/state_management/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

Future<PackageInfo> getAppInfo() async {
  return await PackageInfo.fromPlatform();
}

Color notFoundIconColor(BuildContext context) {
  return Theme.of(context).colorScheme.primary.withAlpha(180);
}

Future<void> logout({
  required BuildContext context,
  required WidgetRef ref,
}) async {
  await FirebaseAuth.instance.signOut();
  ref.invalidate(userProvider);
  if (context.mounted) {
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }
}

/// Monochrome ThemeData for pure black, white, and greyscale UI
final ThemeData monochromeThemeData = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    primary: Colors.black,
    onPrimary: Colors.white,
    secondary: Colors.black,
    onSecondary: Colors.white,
    background: Colors.black,
    onBackground: Colors.white,
    surface: Colors.black,
    onSurface: Colors.white,
    error: Colors.red,
    onError: Colors.white,
  ),
  scaffoldBackgroundColor: Colors.black,
  cardColor: Colors.grey[900], // Slightly lighter for cards
  dividerColor: Colors.grey[800], // Visible but dark
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
    iconTheme: IconThemeData(color: Colors.white),
  ),
  iconTheme: const IconThemeData(color: Colors.white),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white70),
    bodySmall: TextStyle(color: Colors.white54),
    titleLarge: TextStyle(color: Colors.white),
    titleMedium: TextStyle(color: Colors.white70),
    titleSmall: TextStyle(color: Colors.white54),
    labelLarge: TextStyle(color: Colors.white),
    labelMedium: TextStyle(color: Colors.white70),
    labelSmall: TextStyle(color: Colors.white54),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: Colors.black,
    border: OutlineInputBorder(),
    hintStyle: TextStyle(color: Colors.white54),
    labelStyle: TextStyle(color: Colors.white),
  ),
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: Colors.grey,
    contentTextStyle: TextStyle(color: Colors.white),
  ),
  popupMenuTheme: const PopupMenuThemeData(
    color: Colors.black,
    textStyle: TextStyle(color: Colors.white),
  ),
  dialogBackgroundColor: Colors.black,
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Colors.black,
  ),
  drawerTheme: const DrawerThemeData(
    backgroundColor: Colors.black,
  ),
  highlightColor: Colors.grey[800],
  splashColor: Colors.grey[900],
);