import 'package:flutter/widgets.dart';
import 'package:faunty/i18n/strings.g.dart';

String translation(BuildContext context, String value) {
  // Use the full string as the key for dynamic lookup
  return Translations.of(context)[value] ?? value;
}
