import 'package:faunty/components/custom_snackbar.dart';
import 'package:faunty/state_management/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountPage extends ConsumerWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final surfaceColor = theme.colorScheme.surface;
    final onSurface = theme.colorScheme.onSurface;
    final secondary = theme.colorScheme.secondary;

    final userAsync = ref.watch(userProviderStream);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        backgroundColor: surfaceColor,
        foregroundColor: onSurface,
        elevation: 1,
      ),
      body: user == null
          ? Center(
              child: Text(
                'No user is currently signed in.',
                style: theme.textTheme.bodyLarge,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: onSurface,
                        child: Icon(Icons.account_circle, size: 48, color: primaryColor),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.displayName ?? (
                                userAsync.when(
                                  data: (u) => ('${u?.firstName ?? ''} ${u?.lastName ?? ''}').trim().isNotEmpty
                                      ? ('${u?.firstName ?? ''} ${u?.lastName ?? ''}').trim()
                                      : 'No Name',
                                  loading: () => 'Loading...',
                                  error: (_, __) => 'No Name',
                                )
                              ),
                              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              user.email ?? 'No Email',
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Card(
                    color: surfaceColor,
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Account Details', style: theme.textTheme.titleMedium),
                              TextButton.icon(
                                style: TextButton.styleFrom(
                                  foregroundColor: primaryColor,
                                ),
                                icon: const Icon(Icons.edit),
                                label: const Text('Edit'),
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: surfaceColor,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                                    ),
                                    builder: (context) {
                                      final passwordController = TextEditingController();
                                      return Padding(
                                        padding: EdgeInsets.only(
                                          left: 24,
                                          right: 24,
                                          top: 24,
                                          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                                        ),
                                        child: StatefulBuilder(
                                          builder: (context, setModalState) {
                                            bool isLoading = false;
                                            String errorMsg = '';
                                            return StatefulBuilder(
                                              builder: (context, setState) {
                                                return Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text('Change Password', style: theme.textTheme.titleLarge),
                                                    const SizedBox(height: 16),
                                                    TextField(
                                                      controller: passwordController,
                                                      decoration: const InputDecoration(
                                                        labelText: 'New Password',
                                                        prefixIcon: Icon(Icons.lock),
                                                      ),
                                                      obscureText: true,
                                                    ),
                                                    if (errorMsg.isNotEmpty) ...[
                                                      const SizedBox(height: 8),
                                                      Text(errorMsg, style: const TextStyle(color: Colors.red)),
                                                    ],
                                                    const SizedBox(height: 24),
                                                    SizedBox(
                                                      width: double.infinity,
                                                      child: ElevatedButton.icon(
                                                        style: ElevatedButton.styleFrom(
                                                          backgroundColor: primaryColor,
                                                          foregroundColor: surfaceColor,
                                                          padding: const EdgeInsets.symmetric(vertical: 14),
                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                                        ),
                                                        icon: isLoading
                                                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                                                            : const Icon(Icons.save),
                                                        label: const Text('Save Password'),
                                                        onPressed: isLoading
                                                            ? null
                                                            : () async {
                                                                setState(() => isLoading = true);
                                                                try {
                                                                  if (passwordController.text.trim().isEmpty) {
                                                                    throw Exception('Please enter a new password.');
                                                                  }
                                                                  await user.updatePassword(passwordController.text.trim());
                                                                  await user.reload();
                                                                  if (context.mounted) {
                                                                    Navigator.pop(context);
                                                                    // Show success snackbar
                                                                    Future.delayed(const Duration(milliseconds: 300), () {
                                                                      if (context.mounted) {
                                                                        showCustomSnackBar(context, 'Password changed successfully!');
                                                                      }
                                                                    });
                                                                  }
                                                                } catch (e) {
                                                                  final errorStr = e.toString();
                                                                  if (errorStr.contains('requires-recent-login')) {
                                                                    if (context.mounted) {
                                                                      showDialog(
                                                                        context: context,
                                                                        builder: (context) => AlertDialog(
                                                                          title: const Text('Re-authentication Required'),
                                                                          content: const Text(
                                                                            'For security reasons, please log in again to change your password. You will be redirected to the login screen.',
                                                                          ),
                                                                          actions: [
                                                                            TextButton(
                                                                              onPressed: () {
                                                                                Navigator.of(context).pop();
                                                                                Navigator.of(context).pushReplacementNamed('/login');
                                                                              },
                                                                              child: const Text('Log In'),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      );
                                                                    }
                                                                  } else {
                                                                    setState(() {
                                                                      errorMsg = errorStr.replaceFirst('Exception: ', '');
                                                                      isLoading = false;
                                                                    });
                                                                  }
                                                                }
                                                              },
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ListTile(
                            leading: Icon(Icons.verified_user, color: primaryColor),
                            title: Text('UID'),
                            subtitle: Text(user.uid),
                          ),
                          if (user.metadata.creationTime != null)
                            ListTile(
                              leading: Icon(Icons.event, color: primaryColor),
                              title: Text('Created'),
                              subtitle: Text(formatDateTime(user.metadata.creationTime!)),
                            ),
                          if (user.metadata.lastSignInTime != null)
                            ListTile(
                              leading: Icon(Icons.login, color: primaryColor),
                              title: Text('Last Sign-in'),
                              subtitle: Text(formatDateTime(user.metadata.lastSignInTime!)),
                            ),
                          if (user.phoneNumber != null)
                            ListTile(
                              leading: Icon(Icons.phone, color: primaryColor),
                              title: Text('Phone'),
                              subtitle: Text(user.phoneNumber!),
                            ),
                          if (user.photoURL != null)
                            ListTile(
                              leading: Icon(Icons.image, color: primaryColor),
                              title: Text('Profile Photo'),
                              subtitle: Text(user.photoURL!),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  Center(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: surfaceColor,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      icon: const Icon(Icons.logout),
                      label: const Text('Sign Out'),
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        ref.invalidate(userProvider);
                        if (context.mounted) {
                          Navigator.of(context).pushReplacementNamed('/login');
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

String formatDateTime(DateTime dt) {
  final localDt = dt.toLocal();
  final day = localDt.day.toString().padLeft(2, '0');
  final month = localDt.month.toString().padLeft(2, '0');
  final year = localDt.year;
  final hour = localDt.hour.toString().padLeft(2, '0');
  final minute = localDt.minute.toString().padLeft(2, '0');
  return '$day.$month.$year, $hour:$minute';
}
