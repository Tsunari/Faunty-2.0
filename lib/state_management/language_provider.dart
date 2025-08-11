import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../tools/local_storage_helper.dart';
import 'package:flutter/widgets.dart';
import 'package:faunty/i18n/strings.g.dart';

final languageProvider = StateNotifierProvider<LanguageNotifier, String>((ref) => LanguageNotifier());

class LanguageNotifier extends StateNotifier<String> {
  LanguageNotifier() : super('en') {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final code = await LocalStorageHelper.getLanguageCode();
    if (code != null) {
      state = code;
      _setAppLocale(code);
    } else {
      // Use device locale if no persisted value
      final deviceLocale = WidgetsBinding.instance.platformDispatcher.locale.languageCode;
      state = deviceLocale;
      _setAppLocale(deviceLocale);
    }
  }

  void _setAppLocale(String code) {
    // Set the app locale using Slang
    final locale = AppLocale.values.firstWhere(
      (loc) => loc.languageTag == code,
      orElse: () => AppLocale.en,
    );
    LocaleSettings.setLocale(locale);
  }

  Future<void> setLanguage(String code) async {
    state = code;
    await LocalStorageHelper.setLanguageCode(code);
    _setAppLocale(code);
  }
}
