import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final surface = theme.colorScheme.surface;
    final onSurface = theme.colorScheme.onSurface;
    final secondary = theme.colorScheme.secondary;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        backgroundColor: surface,
        foregroundColor: onSurface,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 48,
                  backgroundColor: onSurface,
                  child: Icon(Icons.info_outline, size: 64, color: primary),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Welcome to Faunty 2.0',
                style: textTheme.headlineMedium?.copyWith(
                  color: primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Faunty is your modern management app, designed to simplify daily organization and communication for teams, communities, and organizations. Built with a focus on usability, security, and beautiful design, Faunty helps you stay connected and productive.',
                style: textTheme.bodyLarge?.copyWith(color: onSurface),
              ),
              const SizedBox(height: 32),
              Card(
                color: surface,
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Features', style: textTheme.titleLarge?.copyWith(color: primary, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      FeatureTile(icon: Icons.group, label: 'Team & Community Management'),
                      FeatureTile(icon: Icons.calendar_today, label: 'Weekly Program & Assignments'),
                      FeatureTile(icon: Icons.dining, label: 'Catering & Cleaning Schedules'),
                      FeatureTile(icon: Icons.lock, label: 'Secure Authentication'),
                      FeatureTile(icon: Icons.notifications_active, label: 'Custom Notifications'),
                      FeatureTile(icon: Icons.phone_android, label: 'Responsive & Mobile Friendly'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Card(
                color: surface,
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('About the Project', style: textTheme.titleLarge?.copyWith(color: primary, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      Text(
                        'Faunty 2.0 is built with Flutter and Firebase, ensuring fast performance and real-time updates. Our mission is to empower users with tools that make everyday management effortless and enjoyable.',
                        style: textTheme.bodyMedium?.copyWith(color: onSurface),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Version: 2.0.0\nDeveloped by Omar & Contributors',
                        style: textTheme.bodySmall?.copyWith(color: secondary),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Center(
                child: Text(
                  'Thank you for using Faunty!\nFor feedback or support, contact us at talebelergfc@gmail.com',
                  style: textTheme.bodyMedium?.copyWith(color: onSurface),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FeatureTile extends StatelessWidget {
  final IconData icon;
  final String label;
  const FeatureTile({required this.icon, required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
