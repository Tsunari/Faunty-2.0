import 'package:faunty/components/custom_dropdown.dart';
import 'package:faunty/components/language_dropdown.dart';
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
            ListTile(
              leading: Icon(Icons.palette_outlined, color: primaryColor),
              title: Text(translation(context: context, 'Theme')),
              subtitle: Text(translation(context: context, 'Choose app theme. Dark recommended.')),
              trailing: CustomDropdown(
                value: themeMode,
                items: [
                  DropdownMenuItem(
                    value: AppThemeMode.system,
                    child: Text(translation(context: context, 'System')),
                  ),
                  DropdownMenuItem(
                    value: AppThemeMode.light,
                    child: Text(translation(context: context, 'Light')),
                  ),
                  DropdownMenuItem(
                    value: AppThemeMode.dark,
                    child: Text(translation(context: context, 'Dark')),
                  ),
                ],
                onChanged: (val) {
                  if (val != null) {
                    ref.read(themeProvider.notifier).setTheme(val);
                  }
                },
                borderColor: primaryColor.withOpacity(0.5),
              ),
            ),
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
