import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:faunty/i18n/strings.g.dart';

class LanguageDropdown extends ConsumerWidget {
  final Color? borderColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  const LanguageDropdown({
    Key? key,
    this.borderColor,
    this.borderRadius = 16,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final locale = TranslationProvider.of(context).locale;
    final locales = AppLocale.values;
    final localeNames = {
      AppLocale.en: 'English',
      AppLocale.de: 'Deutsch',
      AppLocale.tr: 'Türkçe',
      AppLocale.ru: 'Русский',
    };
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: borderColor ?? primaryColor.withOpacity(0.5)),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: DropdownButton<AppLocale>(
        value: locale,
        icon: Icon(Icons.arrow_drop_down, color: primaryColor),
        underline: SizedBox(),
        borderRadius: BorderRadius.circular(borderRadius),
        style: Theme.of(context).textTheme.bodyMedium,
        dropdownColor: Theme.of(context).colorScheme.surface,
        items: locales.map((loc) {
          return DropdownMenuItem<AppLocale>(
            value: loc,
            child: Row(
              children: [
                Icon(Icons.flag, size: 18, color: primaryColor),
                const SizedBox(width: 8),
                Text(localeNames[loc] ?? loc.languageTag),
              ],
            ),
          );
        }).toList(),
        onChanged: (newLocale) {
          if (newLocale != null) {
            LocaleSettings.setLocale(newLocale);
          }
        },
      ),
    );
  }
}
