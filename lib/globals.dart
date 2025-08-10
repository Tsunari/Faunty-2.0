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
