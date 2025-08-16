import 'package:faunty/components/language_dropdown.dart';
import 'package:faunty/components/theme_cards_selector.dart';
import 'package:faunty/components/theme_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../tools/translation_helper.dart';
import 'package:faunty/state_management/theme_provider.dart';


class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeAsync = ref.watch(themeProvider);
    Color primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: Text(translation(context: context, 'Settings')),
      ),
      body: themeAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error loading theme: $e')),
        data: (themeMode) => ListView(
          children: [
            ThemeSelector(borderColor: primaryColor),
            const SizedBox(height: 16),
            ThemeCardsSelector(borderColor: primaryColor),
            const SizedBox(height: 16),
            const Divider(),
            ListTile(
              leading: Icon(Icons.language, color: primaryColor),
              title: Text(translation(context: context, 'Language')),
              subtitle: Text(translation(context: context, 'Choose app language.')),
              trailing: LanguageDropdown(borderColor: primaryColor.withOpacity(0.5)),
            ),
          ],
        ),
      ),
    );
  }
}
