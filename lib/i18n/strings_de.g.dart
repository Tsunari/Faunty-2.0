///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'strings.g.dart';

// Path: <root>
class TranslationsDe implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsDe({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.de,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <de>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	late final TranslationsDe _root = this; // ignore: unused_field

	@override 
	TranslationsDe $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsDe(meta: meta ?? this.$meta);

	// Translations
	@override String get more => 'Mehr';
	@override String get mo => 'Mo';
	@override String get tue => 'Di';
	@override String get wed => 'Mi';
	@override String get thu => 'Do';
	@override String get fr => 'Fr';
	@override String get sat => 'Sa';
	@override String get sun => 'So';
	@override String get registration_mode => 'Registrierungsmodus';
	@override String get inactive => 'Inaktiv';
	@override String get enable_or_disable_registration => 'Registrierung aktivieren oder deaktivieren';
	@override String get language => 'Sprache';
	@override String get help => 'Hilfe';
	@override String get faunty => 'Faunty';
	@override String get register => 'Registrieren';
	@override String get login => 'Anmelden';
	@override String get monday => 'Montag';
	@override String get tuesday => 'Dienstag';
	@override String get wednesday => 'Mittwoch';
	@override String get thursday => 'Donnerstag';
	@override String get friday => 'Freitag';
	@override String get saturday => 'Samstag';
	@override String get sunday => 'Sonntag';
	@override String get catering => 'Küchendienst';
	@override String get no_catering_assignments_yet => 'Noch keine Küchendienstaufgaben!';
	@override String get tap_the_edit_button_below_to_assign_users_to_meals_for_the_week => 'Tippen Sie unten auf die Bearbeiten-Schaltfläche, um Benutzer den Mahlzeiten der Woche zuzuweisen.';
	@override String get edit => 'Bearbeiten';
	@override String get cleaning => 'Reinigung';
	@override String get place => 'Ort';
	@override String get assignees => 'Zugewiesene';
	@override String get no_cleaning_places_yet => 'Noch keine Reinigungsorte!';
	@override String get no_users_assigned_to_any_places => 'Keinen Benutzern wurden Orte zugewiesen.';
	@override String get tap_below_to_create_your_first_place_and_start_assigning_users => 'Tippen Sie unten, um Ihren ersten Ort zu erstellen und Benutzer zuzuweisen.';
	@override String get assign_users_to_your_existing_places_using_the_action_button_below => 'Weisen Sie Benutzern Ihre bestehenden Orte mit der untenstehenden Aktionstaste zu.';
	@override String get create_place => 'Ort erstellen';
	@override String get place_name => 'Ortsname';
	@override String get cancel => 'Abbrechen';
	@override String get create => 'Erstellen';
	@override String get no_users_assigned => 'Keine Benutzer zugewiesen';
	@override String get add_place => 'Ort hinzufügen';
	@override String get add => 'Hinzufügen';
	@override String get edit_place => 'Ort bearbeiten';
	@override String get save => 'Speichern';
	@override String get edit_assignments => 'Zuweisungen bearbeiten';
	@override String get no_places_yet => 'Noch keine Orte.';
	@override String get delete_place => 'Ort löschen';
	@override String get waiting_for_userentity_homepage_was_built_without_a_loaded_user => 'Warte auf Benutzer... (Startseite wurde ohne geladenen Benutzer erstellt)';
	@override String get home => 'Startseite';
	@override String get program => 'Programm';
	@override String get no_program_entries_found_for_this_week => 'Keine Programmeinträge für diese Woche gefunden.';
	@override String get error_loading_program_placeholder => 'Fehler beim Laden des Programms: {placeholder}';
	@override String get today => 'Heute';
	@override String get your_next_catering_assignment => 'Ihre nächste Küchendienstaufgabe:';
	@override String get no_upcoming_catering_assignment_found => 'Keine bevorstehende Küchendienstaufgabe gefunden.';
	@override String get catering_wird_geladen => 'Küchendienst wird geladen...';
	@override String get error_loading_catering => 'Fehler beim Laden des Küchendienstes.';
	@override String get no_cleaning_assignments_found => 'Keine Reinigungsaufgaben gefunden.';
	@override String get you_have_no_cleaning_assignment => 'Sie haben keine Reinigungsaufgabe';
	@override String get your_cleaning_assignment => 'Ihre Reinigungsaufgabe:';
	@override String get cleaning_assignments_are_loading => 'Reinigungsaufgaben werden geladen...';
	@override String get error_loading_cleaning_data => 'Fehler beim Laden der Reinigungsdaten.';
	@override String get this_email_is_already_registered => 'Diese E-Mail ist bereits registriert.';
	@override String get password_is_too_weak_please_use_at_least_6_characters => 'Das Passwort ist zu schwach. Bitte verwenden Sie mindestens 6 Zeichen.';
	@override String get please_enter_a_valid_email_address => 'Bitte geben Sie eine gültige E-Mail-Adresse ein.';
	@override String get registration_is_currently_disabled => 'Registrierung ist derzeit deaktiviert.';
	@override String get no_internet_connection_please_check_your_network_and_try_again => 'Keine Internetverbindung. Bitte überprüfen Sie Ihr Netzwerk und versuchen Sie es erneut.';
	@override String get registration_failed => 'Registrierung fehlgeschlagen.';
	@override String get registration_failed_please_try_again => 'Registrierung fehlgeschlagen. Bitte versuchen Sie es erneut.';
	@override String get please_wait => 'Bitte warten...';
	@override String get already_have_an_account_login => 'Haben Sie bereits ein Konto? Anmelden';
	@override String get don_t_have_an_account_register => 'Haben Sie kein Konto? Registrieren';
	@override String get first_name => 'Vorname';
	@override String get last_name => 'Nachname';
	@override String get email => 'E-Mail';
	@override String get password => 'Passwort';
	@override String get hide_password => 'Passwort verbergen';
	@override String get show_password => 'Passwort anzeigen';
	@override String get confirm_password => 'Passwort bestätigen';
	@override String get select_place => 'Ort auswählen';
	@override String get clear_selection => 'Auswahl löschen';
	@override String get about => 'Über';
	@override String get welcome_to_faunty_2_0 => 'Willkommen bei Faunty 2.0';
	@override String get faunty_is_your_modern_management_app_designed_to_simplify_daily_organization_and_communication_for_teams_communities_and_organizations_built_with_a_focus_on_usability_security_and_beautiful_design_faunty_helps_you_stay_connected_and_productive => 'Faunty ist Ihre moderne Management-App, die darauf ausgelegt ist, die tägliche Organisation und Kommunikation für Teams, Gemeinschaften und Organisationen zu vereinfachen. Mit Fokus auf Benutzerfreundlichkeit, Sicherheit und schönes Design hilft Faunty Ihnen, verbunden und produktiv zu bleiben.';
	@override String get features => 'Funktionen';
	@override String get team_community_management => 'Team- & Gemeinschaftsverwaltung';
	@override String get weekly_program_assignments => 'Wöchentliche Programme & Aufgaben';
	@override String get catering_cleaning_schedules => 'Küchendienst- & Reinigungspläne';
	@override String get secure_authentication => 'Sichere Authentifizierung';
	@override String get custom_notifications => 'Benutzerdefinierte Benachrichtigungen';
	@override String get responsive_mobile_friendly => 'Responsiv & Mobilfreundlich';
	@override String get about_the_project => 'Über das Projekt';
	@override String get faunty_2_0_is_built_with_flutter_and_firebase_ensuring_fast_performance_and_real_time_updates_our_mission_is_to_empower_users_with_tools_that_make_everyday_management_effortless_and_enjoyable => 'Faunty 2.0 wurde mit Flutter und Firebase entwickelt und bietet schnelle Leistung und Echtzeit-Updates. Unsere Mission ist es, Benutzer mit Tools auszustatten, die das tägliche Management mühelos und angenehm machen.';
	@override String get thank_you_for_using_faunty => 'Danke, dass Sie Faunty verwenden!';
	@override String get for_feedback_or_support_contact_us_at_talebelergfc_gmail_com => 'Für Feedback oder Support kontaktieren Sie uns unter talebelergfc@gmail.com';
	@override String get account => 'Konto';
	@override String get no_user_is_currently_signed_in => 'Derzeit ist kein Benutzer angemeldet.';
	@override String get account_details => 'Kontodetails';
	@override String get change_password => 'Passwort ändern';
	@override String get new_password => 'Neues Passwort';
	@override String get save_password => 'Passwort speichern';
	@override String get please_enter_a_new_password => 'Bitte geben Sie ein neues Passwort ein.';
	@override String get password_changed_successfully => 'Passwort erfolgreich geändert!';
	@override String get re_authentication_required => 'Erneute Authentifizierung erforderlich';
	@override String get for_security_reasons_please_log_in_again_to_change_your_password_you_will_be_redirected_to_the_login_screen => 'Aus Sicherheitsgründen melden Sie sich bitte erneut an, um Ihr Passwort zu ändern. Sie werden zum Anmeldebildschirm weitergeleitet.';
	@override String get created => 'Erstellt';
	@override String get last_sign_in => 'Letzte Anmeldung';
	@override String get users => 'Benutzer';
	@override String get active => 'Aktiv';
	@override String get statistics => 'Statistiken';
	@override String get backup_and_restore => 'Backup und Wiederherstellung';
	@override String get settings => 'Einstellungen';
	@override String get no_user_loaded => 'Kein Benutzer geladen.';
	@override String get edit_name => 'Name bearbeiten';
	@override String get failed_to_update_name => 'Name konnte nicht aktualisiert werden: ';
	@override String get organisation => 'Organisation';
	@override String get save_as_template => 'Als Vorlage speichern';
	@override String get select_template_to_override => 'Vorlage zum Überschreiben auswählen';
	@override String get template_name => 'Vorlagenname';
	@override String get kOverride => 'Überschreiben';
	@override String get select_a_template => 'Vorlage auswählen';
	@override String get no_templates_found => 'Keine Vorlagen gefunden';
	@override String get delete_template => 'Vorlage löschen';
	@override String get close => 'Schließen';
	@override String get add_new_event => 'Neues Ereignis hinzufügen';
	@override String get edit_event => 'Ereignis bearbeiten';
	@override String get select_start_time => 'Startzeit auswählen';
	@override String get select_end_time => 'Endzeit auswählen';
	@override String get save_and_go_back => 'Speichern und zurückgehen';
	@override String get no_program_entries_for_this_week => 'Keine Programmeinträge für diese Woche!';
	@override String get tap_the_edit_button_below_to_add_a_program_for_the_week => 'Tippen Sie unten auf die Bearbeiten-Schaltfläche, um ein Programm für die Woche hinzuzufügen.';
	@override String get edit_program => 'Programm bearbeiten';
	@override String get i_sincerely_apologize_but_you_can_not_have_more_debt => 'Ich entschuldige mich aufrichtig, aber Sie können nicht mehr Schulden haben.';
	@override String get bro_pay_your_debt_first => 'Bro, zahl erst deine Schulden.';
	@override String get kantin => 'Kantin';
	@override String get a_positive_value_means_you_owe_money_a_negative_value_means_you_have_credit => 'Ein positiver Wert bedeutet, dass Sie Geld schulden. Ein negativer Wert bedeutet, Sie haben Guthaben.';
	@override String get enter_amount => 'Betrag eingeben';
	@override String get other_users => 'Andere Nutzer';
	@override String get no_other_users_found => 'Keine anderen Nutzer gefunden';
	@override String get debt => 'Schulden';
	@override String get paypal => 'PayPal';
	@override String get did_you_pay => 'Haben Sie bezahlt ';
	@override String get via_paypal => ' € via PayPal?';
	@override String get yes => 'Ja';
	@override String get reset_debt => 'Schulden zurücksetzen';
	@override String get are_you_sure_you_want_to_reset_your_debt_to_0 => 'Sind Sie sicher, dass Sie Ihre Schulden auf 0 zurücksetzen möchten?';
	@override String get confirm => 'Bestätigen';
	@override String get debt_reset => 'Schulden zurückgesetzt!';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.
extension on TranslationsDe {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'more': return 'Mehr';
			case 'mo': return 'Mo';
			case 'tue': return 'Di';
			case 'wed': return 'Mi';
			case 'thu': return 'Do';
			case 'fr': return 'Fr';
			case 'sat': return 'Sa';
			case 'sun': return 'So';
			case 'registration_mode': return 'Registrierungsmodus';
			case 'inactive': return 'Inaktiv';
			case 'enable_or_disable_registration': return 'Registrierung aktivieren oder deaktivieren';
			case 'language': return 'Sprache';
			case 'help': return 'Hilfe';
			case 'faunty': return 'Faunty';
			case 'register': return 'Registrieren';
			case 'login': return 'Anmelden';
			case 'monday': return 'Montag';
			case 'tuesday': return 'Dienstag';
			case 'wednesday': return 'Mittwoch';
			case 'thursday': return 'Donnerstag';
			case 'friday': return 'Freitag';
			case 'saturday': return 'Samstag';
			case 'sunday': return 'Sonntag';
			case 'catering': return 'Küchendienst';
			case 'no_catering_assignments_yet': return 'Noch keine Küchendienstaufgaben!';
			case 'tap_the_edit_button_below_to_assign_users_to_meals_for_the_week': return 'Tippen Sie unten auf die Bearbeiten-Schaltfläche, um Benutzer den Mahlzeiten der Woche zuzuweisen.';
			case 'edit': return 'Bearbeiten';
			case 'cleaning': return 'Reinigung';
			case 'place': return 'Ort';
			case 'assignees': return 'Zugewiesene';
			case 'no_cleaning_places_yet': return 'Noch keine Reinigungsorte!';
			case 'no_users_assigned_to_any_places': return 'Keinen Benutzern wurden Orte zugewiesen.';
			case 'tap_below_to_create_your_first_place_and_start_assigning_users': return 'Tippen Sie unten, um Ihren ersten Ort zu erstellen und Benutzer zuzuweisen.';
			case 'assign_users_to_your_existing_places_using_the_action_button_below': return 'Weisen Sie Benutzern Ihre bestehenden Orte mit der untenstehenden Aktionstaste zu.';
			case 'create_place': return 'Ort erstellen';
			case 'place_name': return 'Ortsname';
			case 'cancel': return 'Abbrechen';
			case 'create': return 'Erstellen';
			case 'no_users_assigned': return 'Keine Benutzer zugewiesen';
			case 'add_place': return 'Ort hinzufügen';
			case 'add': return 'Hinzufügen';
			case 'edit_place': return 'Ort bearbeiten';
			case 'save': return 'Speichern';
			case 'edit_assignments': return 'Zuweisungen bearbeiten';
			case 'no_places_yet': return 'Noch keine Orte.';
			case 'delete_place': return 'Ort löschen';
			case 'waiting_for_userentity_homepage_was_built_without_a_loaded_user': return 'Warte auf Benutzer... (Startseite wurde ohne geladenen Benutzer erstellt)';
			case 'home': return 'Startseite';
			case 'program': return 'Programm';
			case 'no_program_entries_found_for_this_week': return 'Keine Programmeinträge für diese Woche gefunden.';
			case 'error_loading_program_placeholder': return 'Fehler beim Laden des Programms: {placeholder}';
			case 'today': return 'Heute';
			case 'your_next_catering_assignment': return 'Ihre nächste Küchendienstaufgabe:';
			case 'no_upcoming_catering_assignment_found': return 'Keine bevorstehende Küchendienstaufgabe gefunden.';
			case 'catering_wird_geladen': return 'Küchendienst wird geladen...';
			case 'error_loading_catering': return 'Fehler beim Laden des Küchendienstes.';
			case 'no_cleaning_assignments_found': return 'Keine Reinigungsaufgaben gefunden.';
			case 'you_have_no_cleaning_assignment': return 'Sie haben keine Reinigungsaufgabe';
			case 'your_cleaning_assignment': return 'Ihre Reinigungsaufgabe:';
			case 'cleaning_assignments_are_loading': return 'Reinigungsaufgaben werden geladen...';
			case 'error_loading_cleaning_data': return 'Fehler beim Laden der Reinigungsdaten.';
			case 'this_email_is_already_registered': return 'Diese E-Mail ist bereits registriert.';
			case 'password_is_too_weak_please_use_at_least_6_characters': return 'Das Passwort ist zu schwach. Bitte verwenden Sie mindestens 6 Zeichen.';
			case 'please_enter_a_valid_email_address': return 'Bitte geben Sie eine gültige E-Mail-Adresse ein.';
			case 'registration_is_currently_disabled': return 'Registrierung ist derzeit deaktiviert.';
			case 'no_internet_connection_please_check_your_network_and_try_again': return 'Keine Internetverbindung. Bitte überprüfen Sie Ihr Netzwerk und versuchen Sie es erneut.';
			case 'registration_failed': return 'Registrierung fehlgeschlagen.';
			case 'registration_failed_please_try_again': return 'Registrierung fehlgeschlagen. Bitte versuchen Sie es erneut.';
			case 'please_wait': return 'Bitte warten...';
			case 'already_have_an_account_login': return 'Haben Sie bereits ein Konto? Anmelden';
			case 'don_t_have_an_account_register': return 'Haben Sie kein Konto? Registrieren';
			case 'first_name': return 'Vorname';
			case 'last_name': return 'Nachname';
			case 'email': return 'E-Mail';
			case 'password': return 'Passwort';
			case 'hide_password': return 'Passwort verbergen';
			case 'show_password': return 'Passwort anzeigen';
			case 'confirm_password': return 'Passwort bestätigen';
			case 'select_place': return 'Ort auswählen';
			case 'clear_selection': return 'Auswahl löschen';
			case 'about': return 'Über';
			case 'welcome_to_faunty_2_0': return 'Willkommen bei Faunty 2.0';
			case 'faunty_is_your_modern_management_app_designed_to_simplify_daily_organization_and_communication_for_teams_communities_and_organizations_built_with_a_focus_on_usability_security_and_beautiful_design_faunty_helps_you_stay_connected_and_productive': return 'Faunty ist Ihre moderne Management-App, die darauf ausgelegt ist, die tägliche Organisation und Kommunikation für Teams, Gemeinschaften und Organisationen zu vereinfachen. Mit Fokus auf Benutzerfreundlichkeit, Sicherheit und schönes Design hilft Faunty Ihnen, verbunden und produktiv zu bleiben.';
			case 'features': return 'Funktionen';
			case 'team_community_management': return 'Team- & Gemeinschaftsverwaltung';
			case 'weekly_program_assignments': return 'Wöchentliche Programme & Aufgaben';
			case 'catering_cleaning_schedules': return 'Küchendienst- & Reinigungspläne';
			case 'secure_authentication': return 'Sichere Authentifizierung';
			case 'custom_notifications': return 'Benutzerdefinierte Benachrichtigungen';
			case 'responsive_mobile_friendly': return 'Responsiv & Mobilfreundlich';
			case 'about_the_project': return 'Über das Projekt';
			case 'faunty_2_0_is_built_with_flutter_and_firebase_ensuring_fast_performance_and_real_time_updates_our_mission_is_to_empower_users_with_tools_that_make_everyday_management_effortless_and_enjoyable': return 'Faunty 2.0 wurde mit Flutter und Firebase entwickelt und bietet schnelle Leistung und Echtzeit-Updates. Unsere Mission ist es, Benutzer mit Tools auszustatten, die das tägliche Management mühelos und angenehm machen.';
			case 'thank_you_for_using_faunty': return 'Danke, dass Sie Faunty verwenden!';
			case 'for_feedback_or_support_contact_us_at_talebelergfc_gmail_com': return 'Für Feedback oder Support kontaktieren Sie uns unter talebelergfc@gmail.com';
			case 'account': return 'Konto';
			case 'no_user_is_currently_signed_in': return 'Derzeit ist kein Benutzer angemeldet.';
			case 'account_details': return 'Kontodetails';
			case 'change_password': return 'Passwort ändern';
			case 'new_password': return 'Neues Passwort';
			case 'save_password': return 'Passwort speichern';
			case 'please_enter_a_new_password': return 'Bitte geben Sie ein neues Passwort ein.';
			case 'password_changed_successfully': return 'Passwort erfolgreich geändert!';
			case 're_authentication_required': return 'Erneute Authentifizierung erforderlich';
			case 'for_security_reasons_please_log_in_again_to_change_your_password_you_will_be_redirected_to_the_login_screen': return 'Aus Sicherheitsgründen melden Sie sich bitte erneut an, um Ihr Passwort zu ändern. Sie werden zum Anmeldebildschirm weitergeleitet.';
			case 'created': return 'Erstellt';
			case 'last_sign_in': return 'Letzte Anmeldung';
			case 'users': return 'Benutzer';
			case 'active': return 'Aktiv';
			case 'statistics': return 'Statistiken';
			case 'backup_and_restore': return 'Backup und Wiederherstellung';
			case 'settings': return 'Einstellungen';
			case 'no_user_loaded': return 'Kein Benutzer geladen.';
			case 'edit_name': return 'Name bearbeiten';
			case 'failed_to_update_name': return 'Name konnte nicht aktualisiert werden: ';
			case 'organisation': return 'Organisation';
			case 'save_as_template': return 'Als Vorlage speichern';
			case 'select_template_to_override': return 'Vorlage zum Überschreiben auswählen';
			case 'template_name': return 'Vorlagenname';
			case 'kOverride': return 'Überschreiben';
			case 'select_a_template': return 'Vorlage auswählen';
			case 'no_templates_found': return 'Keine Vorlagen gefunden';
			case 'delete_template': return 'Vorlage löschen';
			case 'close': return 'Schließen';
			case 'add_new_event': return 'Neues Ereignis hinzufügen';
			case 'edit_event': return 'Ereignis bearbeiten';
			case 'select_start_time': return 'Startzeit auswählen';
			case 'select_end_time': return 'Endzeit auswählen';
			case 'save_and_go_back': return 'Speichern und zurückgehen';
			case 'no_program_entries_for_this_week': return 'Keine Programmeinträge für diese Woche!';
			case 'tap_the_edit_button_below_to_add_a_program_for_the_week': return 'Tippen Sie unten auf die Bearbeiten-Schaltfläche, um ein Programm für die Woche hinzuzufügen.';
			case 'edit_program': return 'Programm bearbeiten';
			case 'i_sincerely_apologize_but_you_can_not_have_more_debt': return 'Ich entschuldige mich aufrichtig, aber Sie können nicht mehr Schulden haben.';
			case 'bro_pay_your_debt_first': return 'Bro, zahl erst deine Schulden.';
			case 'kantin': return 'Kantin';
			case 'a_positive_value_means_you_owe_money_a_negative_value_means_you_have_credit': return 'Ein positiver Wert bedeutet, dass Sie Geld schulden. Ein negativer Wert bedeutet, Sie haben Guthaben.';
			case 'enter_amount': return 'Betrag eingeben';
			case 'other_users': return 'Andere Nutzer';
			case 'no_other_users_found': return 'Keine anderen Nutzer gefunden';
			case 'debt': return 'Schulden';
			case 'paypal': return 'PayPal';
			case 'did_you_pay': return 'Haben Sie bezahlt ';
			case 'via_paypal': return ' € via PayPal?';
			case 'yes': return 'Ja';
			case 'reset_debt': return 'Schulden zurücksetzen';
			case 'are_you_sure_you_want_to_reset_your_debt_to_0': return 'Sind Sie sicher, dass Sie Ihre Schulden auf 0 zurücksetzen möchten?';
			case 'confirm': return 'Bestätigen';
			case 'debt_reset': return 'Schulden zurückgesetzt!';
			default: return null;
		}
	}
}

