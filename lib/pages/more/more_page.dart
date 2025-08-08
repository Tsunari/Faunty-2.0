import 'package:faunty/components/role_gate.dart';
import 'package:faunty/firestore/globals_firestore_service.dart';
import 'package:faunty/models/user_roles.dart';
import 'package:faunty/pages/more/about_page.dart';
import 'package:faunty/pages/more/account_page.dart';
import 'package:faunty/state_management/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../state_management/globals_provider.dart';
import 'users_page.dart';
import '../../components/custom_chip.dart';

class MorePage extends ConsumerWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color primaryColor = Theme.of(context).colorScheme.primary;

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const SizedBox(height: 80),
        // Hero image at the top
        Center(
          child: Hero(
            tag: 'logo',
            child: GestureDetector(
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                ref.invalidate(userProvider);
                if (context.mounted) {
                  // Navigate to login page
                  Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
                }
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 100,
                    child: Image(
                      image: const AssetImage('assets/LogoInverse.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Divider(),
        // SwitchListTile(
        //   secondary: Icon(Icons.dark_mode_outlined, color: primaryColor),
        //   title: const Text('Dark Mode'),
        //   subtitle: const Text('Switch between light and dark mode'),
        //   value: darkMode,
        //   onChanged: (val) {
        //     setState(() => darkMode = val);
        //   },
        // ),
        RoleGate(
          minRole: UserRole.hoca,
          child: Consumer(
            builder: (context, ref, _) {
              final globalsAsync = ref.watch(globalsProvider);
              final userAsync = ref.watch(userProvider);
              final user = userAsync.asData?.value;
              return globalsAsync.when(
                loading: () => const SwitchListTile(
                  secondary: Icon(Icons.app_registration_outlined),
                  title: Text('Registration Mode'),
                  value: false,
                  onChanged: null,
                ),
                error: (e, st) => ListTile(
                  leading: Icon(Icons.error, color: Colors.red),
                  title: Text('Error loading registration mode'),
                  subtitle: Text(e.toString()),
                ),
                data: (globals) => SwitchListTile(
                  secondary: Icon(Icons.app_registration_outlined, color: primaryColor),
                  title: Row(
                    children: [
                      const Text('Registration Mode'),
                      const SizedBox(width: 4),
                      CustomChip(label: globals.registrationMode ? 'Active' : 'Inactive'),
                    ],
                  ),
                  subtitle: const Text('Enable or disable registration'),
                  value: globals.registrationMode,
                  onChanged: (val) async {
                    if (user == null) return;
                    final service = GlobalsFirestoreService(user.placeId);
                    await service.setGlobalField('registrationMode', val);
                  },
                ),
              );
            },
          ),
        ),
        RoleGate(minRole: UserRole.hoca, child: const Divider()),
        ListTile(
          leading: Icon(Icons.account_circle_outlined, color: primaryColor),
          title: Row(
              children: [
                const Text('Account'),
                const SizedBox(width: 4),
                CustomChip(label: 'Active'),
              ],
            ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const AccountPage(),
              ),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.group_outlined, color: primaryColor),
          title: Row(
            children: [
              const Text('Users'),
              const SizedBox(width: 4),
              CustomChip(
                label: 'Active',
              ),
            ],
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const UsersPage(),
              ),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.bar_chart_outlined, color: primaryColor),
          title: const Text('Statistics'),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.backup_outlined, color: primaryColor),
          title: const Text('Backup and restore'),
          onTap: () {},
        ),
        const Divider(),
        ListTile(
          leading: Icon(Icons.settings_outlined, color: primaryColor),
          title: const Text('Settings'),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.info_outline, color: primaryColor),
          title: Row(
              children: [
                const Text('About'),
                const SizedBox(width: 4),
                CustomChip(label: 'Active'),
              ],
            ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const AboutPage(),
              ),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.help_outline, color: primaryColor),
          title: const Text('Help'),
          onTap: () {},
        ),
      ],
    );
  }
}
