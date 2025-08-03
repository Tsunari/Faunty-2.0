import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MorePage extends StatefulWidget {
  const MorePage({super.key});

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  bool darkMode = false;
  bool registrationMode = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const SizedBox(height: 70),
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
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.logout,
                          size: 18,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Click to log out',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Divider(),
        SwitchListTile(
          secondary: const Icon(Icons.dark_mode_outlined),
          title: const Text('Dark Mode'),
          subtitle: const Text('Switch between light and dark mode'),
          value: darkMode,
          onChanged: (val) {
            setState(() => darkMode = val);
          },
        ),
        SwitchListTile(
          secondary: const Icon(Icons.app_registration_outlined),
          title: const Text('Registration Mode'),
          subtitle: const Text('Enable or disable registration'),
          value: registrationMode,
          onChanged: (val) {
            setState(() => registrationMode = val);
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.account_circle_outlined),
          title: const Text('Account'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.group_outlined),
          title: const Text('Roles'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.bar_chart_outlined),
          title: const Text('Statistics'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.backup_outlined),
          title: const Text('Backup and restore'),
          onTap: () {},
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.settings_outlined),
          title: const Text('Settings'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('About'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.help_outline),
          title: const Text('Help'),
          onTap: () {},
        ),
      ],
    );
  }
}
