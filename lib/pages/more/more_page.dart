import 'package:faunty/components/role_gate.dart';
import 'package:faunty/models/user_roles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../state_management/globals_provider.dart';

class MorePage extends ConsumerWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color primaryColor = Theme.of(context).colorScheme.primary;
    final globals = ref.watch(globalsProvider);
    final globalsNotifier = ref.read(globalsProvider.notifier);
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const SizedBox(height: 80),
        // Hero image at the top
        Center(
          child: Hero(
            tag: 'mosque',
            child: GestureDetector(
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/login');
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
          child: SwitchListTile(
            secondary: Icon(Icons.app_registration_outlined, color: primaryColor),
            title: const Text('Registration Mode'),
            subtitle: const Text('Enable or disable registration'),
            value: globals.registrationMode,
            onChanged: (val) {
              globalsNotifier.setRegistrationMode(val);
            },
          ),
        ),
        RoleGate(minRole: UserRole.hoca, child: const Divider()),
        ListTile(
          leading: Icon(Icons.account_circle_outlined, color: primaryColor),
          title: const Text('Account'),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.group_outlined, color: primaryColor),
          title: const Text('Users'),
          onTap: () {},
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
          title: const Text('About'),
          onTap: () {},
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
