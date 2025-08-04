import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state_management/user_provider.dart';
import '../models/user_roles.dart';

/// A widget that only renders its child if the current user's role is equal to or higher than [minRole].
/// Optionally, you can provide a [fallback] widget to show if the user does not have permission.
class RoleGate extends ConsumerWidget {
  final UserRole minRole;
  final Widget child;
  final Widget? fallback;

  const RoleGate({
    super.key,
    required this.minRole,
    required this.child,
    this.fallback,
  });

  /// Returns the index of the role in the hierarchy (lower index = higher privilege).
  int _roleIndex(UserRole role) {
    switch (role) {
      case UserRole.superuser:
        return 0;
      case UserRole.hoca:
        return 1;
      case UserRole.baskan:
        return 2;
      case UserRole.talebe:
        return 3;
      case UserRole.user:
        return 4;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    if (user == null) {
      // Not logged in or user not loaded
      return fallback ?? const SizedBox.shrink();
    }
    final userRole = user.role;
    if (_roleIndex(userRole) <= _roleIndex(minRole)) {
      return child;
    } else {
      return fallback ?? const SizedBox.shrink();
    }
  }
}
