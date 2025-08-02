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
            child: SizedBox(
              height: 100,
              child: Image(
                image: AssetImage('assets/LogoInverse.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Divider(),
        SwitchListTile(
          title: const Text('Dark Mode'),
          subtitle: const Text('Switch between light and dark mode'),
          value: darkMode,
          onChanged: (val) {
            setState(() => darkMode = val);
          },
        ),
        SwitchListTile(
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
