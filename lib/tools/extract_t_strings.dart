// Dart script to extract all t("...") usages and update translation JSON
import 'dart:io';
import 'dart:convert';
// import 'package:path/path.dart' as p; // Not needed

// Change these paths as needed
const dartSourceDir = 'lib';
const translationJsonPath = 'lib/i18n/en.i18n.json';

// Generates a slug key from the string value
String generateKey(String value) {
  final slug = value
    .toLowerCase()
    .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
    .replaceAll(RegExp(r'^_+|_+$'), '');
  return slug.length > 40 ? slug.substring(0, 40) : slug;
}

void main() async {
  final translationFile = File(translationJsonPath);
  Map<String, dynamic> translations = {};
  if (await translationFile.exists()) {
    translations = json.decode(await translationFile.readAsString());
  }

  final dartFiles = Directory(dartSourceDir)
      .listSync(recursive: true)
      .where((f) => f.path.endsWith('.dart'));

  final tDoubleRegex = RegExp(r'translation\(\s*context\s*,\s*"([^"]+)"\s*\)');
  final tSingleRegex = RegExp(r"translation\(\s*context\s*,\s*'([^']+)'\s*\)");
  final found = <String>{};

  for (final file in dartFiles) {
    final content = await File(file.path).readAsString();
    for (final match in tDoubleRegex.allMatches(content)) {
      final str = match.group(1);
      if (str != null && str.isNotEmpty) {
        found.add(str);
      }
    }
    for (final match in tSingleRegex.allMatches(content)) {
      final str = match.group(1);
      if (str != null && str.isNotEmpty) {
        found.add(str);
      }
    }
  }

  // Check for missing translations (value not found in any value of JSON)
  final missing = <String, String>{};
  for (final value in found) {
    if (!translations.containsKey(value) && !translations.values.contains(value)) {
      missing[value] = value;
    }
  }

  if (missing.isEmpty) {
    print('No missing translations found.');
    return;
  }

  // Pretty print missing translations
  print('\nMissing translations:');
  print('----------------------------------------------');
  print('| Key                                  | Value');
  print('----------------------------------------------');
  for (final entry in missing.entries) {
    final key = entry.key.padRight(36);
    final value = entry.value;
    print('| $key | $value');
  }

  print('\nTotal missing translations: ${missing.length}');

  stdout.write('\nAdd these to $translationJsonPath? (Y/n): ');
  final response = stdin.readLineSync();
  if (response != null && response.toLowerCase() == 'n') {
    print('Aborted. No changes made.');
    return;
  }

  // Add missing translations
  translations.addAll(missing);
  await translationFile.writeAsString(JsonEncoder.withIndent('  ').convert(translations));
  print('Done. ${missing.length} new keys added to $translationJsonPath');
}
