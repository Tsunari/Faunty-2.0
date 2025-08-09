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
class TranslationsRu implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsRu({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.ru,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <ru>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	late final TranslationsRu _root = this; // ignore: unused_field

	@override 
	TranslationsRu $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsRu(meta: meta ?? this.$meta);

	// Translations
	@override String get more => 'Ещё';
	@override String get Mo => 'Пн';
	@override String get Tue => 'Вт';
	@override String get Wed => 'Ср';
	@override String get Thu => 'Чт';
	@override String get Fr => 'Пт';
	@override String get Sat => 'Сб';
	@override String get Sun => 'Вс';
	@override String get registration_mode => 'Режим регистрации';
	@override String get inactive => 'Неактивно';
	@override String get enable_or_disable_registration => 'Включить или отключить регистрацию';
	@override String get language => 'Язык';
	@override String get help => 'Помощь';
	@override String get Faunty => 'Faunty';
	@override String get Register => 'Регистрация';
	@override String get Login => 'Войти';
	@override String get monday => 'Понедельник';
	@override String get tuesday => 'Вторник';
	@override String get wednesday => 'Среда';
	@override String get thursday => 'Четверг';
	@override String get friday => 'Пятница';
	@override String get saturday => 'Суббота';
	@override String get sunday => 'Воскресенье';
	@override String get catering => 'Питание';
	@override String get no_catering_assignments_yet => 'Пока нет назначений по питанию!';
	@override String get tap_the_edit_button_below_to_assign_users_to_meals_for_the_week => 'Нажмите кнопку редактирования ниже, чтобы назначить пользователей на питание на неделю.';
	@override String get edit => 'Редактировать';
	@override String get cleaning => 'Уборка';
	@override String get place => 'Место';
	@override String get assignees => 'Назначенные';
	@override String get no_cleaning_places_yet => 'Пока нет мест для уборки!';
	@override String get no_users_assigned_to_any_places => 'Нет назначенных пользователей ни на одно место.';
	@override String get tap_below_to_create_your_first_place_and_start_assigning_users => 'Нажмите ниже, чтобы создать первое место и начать назначать пользователей.';
	@override String get assign_users_to_your_existing_places_using_the_action_button_below => 'Назначайте пользователей на существующие места с помощью кнопки действия ниже.';
	@override String get create_place => 'Создать место';
	@override String get place_name => 'Название места';
	@override String get cancel => 'Отмена';
	@override String get create => 'Создать';
	@override String get no_users_assigned => 'Нет назначенных пользователей';
	@override String get add_place => 'Добавить место';
	@override String get add => 'Добавить';
	@override String get edit_place => 'Редактировать место';
	@override String get save => 'Сохранить';
	@override String get edit_assignments => 'Редактировать назначения';
	@override String get no_places_yet => 'Пока нет мест.';
	@override String get delete_place => 'Удалить место';
	@override String get waiting_for_userentity_homepage_was_built_without_a_loaded_user => 'Ожидание пользователя... (Главная страница создана без загруженного пользователя)';
	@override String get home => 'Главная';
	@override String get program => 'Программа';
	@override String get no_program_entries_found_for_this_week => 'Нет записей программы на эту неделю.';
	@override String get error_loading_program_placeholder => 'Ошибка загрузки программы: {placeholder}';
	@override String get today => 'Сегодня';
	@override String get your_next_catering_assignment => 'Ваше следующее назначение по питанию:';
	@override String get no_upcoming_catering_assignment_found => 'Нет предстоящих назначений по питанию.';
	@override String get catering_wird_geladen => 'Питание загружается...';
	@override String get error_loading_catering => 'Ошибка загрузки питания.';
	@override String get no_cleaning_assignments_found => 'Нет назначений по уборке.';
	@override String get you_have_no_cleaning_assignment => 'У вас нет назначений по уборке';
	@override String get your_cleaning_assignment => 'Ваше назначение по уборке:';
	@override String get cleaning_assignments_are_loading => 'Назначения по уборке загружаются...';
	@override String get error_loading_cleaning_data => 'Ошибка загрузки данных по уборке.';
	@override String get this_email_is_already_registered => 'Этот email уже зарегистрирован.';
	@override String get password_is_too_weak_please_use_at_least_6_characters => 'Пароль слишком слабый. Пожалуйста, используйте не менее 6 символов.';
	@override String get please_enter_a_valid_email_address => 'Пожалуйста, введите действительный email адрес.';
	@override String get registration_is_currently_disabled => 'Регистрация в настоящее время отключена.';
	@override String get no_internet_connection_please_check_your_network_and_try_again => 'Нет интернет-соединения. Проверьте сеть и попробуйте снова.';
	@override String get registration_failed => 'Регистрация не удалась.';
	@override String get registration_failed_please_try_again => 'Регистрация не удалась. Пожалуйста, попробуйте снова.';
	@override String get please_wait => 'Пожалуйста, подождите...';
	@override String get already_have_an_account_login => 'Уже есть аккаунт? Войти';
	@override String get don_t_have_an_account_register => 'Нет аккаунта? Зарегистрироваться';
	@override String get first_name => 'Имя';
	@override String get last_name => 'Фамилия';
	@override String get email => 'Email';
	@override String get password => 'Пароль';
	@override String get hide_password => 'Скрыть пароль';
	@override String get show_password => 'Показать пароль';
	@override String get confirm_password => 'Подтвердить пароль';
	@override String get select_place => 'Выбрать место';
	@override String get clear_selection => 'Очистить выбор';
	@override String get about => 'О приложении';
	@override String get welcome_to_faunty_2_0 => 'Добро пожаловать в Faunty 2.0';
	@override String get faunty_is_your_modern_management_app_designed_to_simplify_daily_organization_and_communication_for_teams_communities_and_organizations_built_with_a_focus_on_usability_security_and_beautiful_design_faunty_helps_you_stay_connected_and_productive => 'Faunty — это современное приложение для управления, созданное для упрощения ежедневной организации и коммуникации для команд, сообществ и организаций. С акцентом на удобство, безопасность и красивый дизайн Faunty помогает оставаться на связи и быть продуктивным.';
	@override String get features => 'Функции';
	@override String get team_community_management => 'Управление командой и сообществом';
	@override String get weekly_program_assignments => 'Еженедельная программа и назначения';
	@override String get catering_cleaning_schedules => 'Графики питания и уборки';
	@override String get secure_authentication => 'Безопасная аутентификация';
	@override String get custom_notifications => 'Пользовательские уведомления';
	@override String get responsive_mobile_friendly => 'Адаптивный и мобильный интерфейс';
	@override String get about_the_project => 'О проекте';
	@override String get faunty_2_0_is_built_with_flutter_and_firebase_ensuring_fast_performance_and_real_time_updates_our_mission_is_to_empower_users_with_tools_that_make_everyday_management_effortless_and_enjoyable => 'Faunty 2.0 создан на Flutter и Firebase, обеспечивая высокую производительность и обновления в реальном времени. Наша миссия — дать пользователям инструменты для легкого и приятного управления каждый день.';
	@override String get thank_you_for_using_faunty => 'Спасибо, что используете Faunty!';
	@override String get for_feedback_or_support_contact_us_at_talebelergfc_gmail_com => 'Для обратной связи или поддержки пишите на talebelergfc@gmail.com';
	@override String get account => 'Аккаунт';
	@override String get no_user_is_currently_signed_in => 'В настоящее время никто не вошел в систему.';
	@override String get account_details => 'Детали аккаунта';
	@override String get change_password => 'Сменить пароль';
	@override String get new_password => 'Новый пароль';
	@override String get save_password => 'Сохранить пароль';
	@override String get please_enter_a_new_password => 'Пожалуйста, введите новый пароль.';
	@override String get password_changed_successfully => 'Пароль успешно изменен!';
	@override String get re_authentication_required => 'Требуется повторная аутентификация';
	@override String get for_security_reasons_please_log_in_again_to_change_your_password_you_will_be_redirected_to_the_login_screen => 'По соображениям безопасности войдите снова, чтобы изменить пароль. Вы будете перенаправлены на экран входа.';
	@override String get created => 'Создано';
	@override String get last_sign_in => 'Последний вход';
	@override String get users => 'Пользователи';
	@override String get active => 'Активный';
	@override String get statistics => 'Статистика';
	@override String get backup_and_restore => 'Резервное копирование и восстановление';
	@override String get settings => 'Настройки';
	@override String get no_user_loaded => 'Пользователь не загружен.';
	@override String get edit_name => 'Редактировать имя';
	@override String get failed_to_update_name => 'Не удалось обновить имя: ';
	@override String get organisation => 'Организация';
	@override String get save_as_template => 'Сохранить как шаблон';
	@override String get select_template_to_override => 'Выберите шаблон для перезаписи';
	@override String get template_name => 'Название шаблона';
	@override String get kOverride => 'Перезаписать';
	@override String get select_a_template => 'Выберите шаблон';
	@override String get no_templates_found => 'Шаблоны не найдены';
	@override String get delete_template => 'Удалить шаблон';
	@override String get close => 'Закрыть';
	@override String get add_new_event => 'Добавить новое событие';
	@override String get edit_event => 'Редактировать событие';
	@override String get select_start_time => 'Выбрать время начала';
	@override String get select_end_time => 'Выбрать время окончания';
	@override String get save_and_go_back => 'Сохранить и вернуться';
	@override String get no_program_entries_for_this_week => 'Нет записей программы на эту неделю!';
	@override String get tap_the_edit_button_below_to_add_a_program_for_the_week => 'Нажмите кнопку редактирования ниже, чтобы добавить программу на неделю.';
	@override String get edit_program => 'Редактировать программу';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.
extension on TranslationsRu {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'more': return 'Ещё';
			case 'Mo': return 'Пн';
			case 'Tue': return 'Вт';
			case 'Wed': return 'Ср';
			case 'Thu': return 'Чт';
			case 'Fr': return 'Пт';
			case 'Sat': return 'Сб';
			case 'Sun': return 'Вс';
			case 'registration_mode': return 'Режим регистрации';
			case 'inactive': return 'Неактивно';
			case 'enable_or_disable_registration': return 'Включить или отключить регистрацию';
			case 'language': return 'Язык';
			case 'help': return 'Помощь';
			case 'Faunty': return 'Faunty';
			case 'Register': return 'Регистрация';
			case 'Login': return 'Войти';
			case 'monday': return 'Понедельник';
			case 'tuesday': return 'Вторник';
			case 'wednesday': return 'Среда';
			case 'thursday': return 'Четверг';
			case 'friday': return 'Пятница';
			case 'saturday': return 'Суббота';
			case 'sunday': return 'Воскресенье';
			case 'catering': return 'Питание';
			case 'no_catering_assignments_yet': return 'Пока нет назначений по питанию!';
			case 'tap_the_edit_button_below_to_assign_users_to_meals_for_the_week': return 'Нажмите кнопку редактирования ниже, чтобы назначить пользователей на питание на неделю.';
			case 'edit': return 'Редактировать';
			case 'cleaning': return 'Уборка';
			case 'place': return 'Место';
			case 'assignees': return 'Назначенные';
			case 'no_cleaning_places_yet': return 'Пока нет мест для уборки!';
			case 'no_users_assigned_to_any_places': return 'Нет назначенных пользователей ни на одно место.';
			case 'tap_below_to_create_your_first_place_and_start_assigning_users': return 'Нажмите ниже, чтобы создать первое место и начать назначать пользователей.';
			case 'assign_users_to_your_existing_places_using_the_action_button_below': return 'Назначайте пользователей на существующие места с помощью кнопки действия ниже.';
			case 'create_place': return 'Создать место';
			case 'place_name': return 'Название места';
			case 'cancel': return 'Отмена';
			case 'create': return 'Создать';
			case 'no_users_assigned': return 'Нет назначенных пользователей';
			case 'add_place': return 'Добавить место';
			case 'add': return 'Добавить';
			case 'edit_place': return 'Редактировать место';
			case 'save': return 'Сохранить';
			case 'edit_assignments': return 'Редактировать назначения';
			case 'no_places_yet': return 'Пока нет мест.';
			case 'delete_place': return 'Удалить место';
			case 'waiting_for_userentity_homepage_was_built_without_a_loaded_user': return 'Ожидание пользователя... (Главная страница создана без загруженного пользователя)';
			case 'home': return 'Главная';
			case 'program': return 'Программа';
			case 'no_program_entries_found_for_this_week': return 'Нет записей программы на эту неделю.';
			case 'error_loading_program_placeholder': return 'Ошибка загрузки программы: {placeholder}';
			case 'today': return 'Сегодня';
			case 'your_next_catering_assignment': return 'Ваше следующее назначение по питанию:';
			case 'no_upcoming_catering_assignment_found': return 'Нет предстоящих назначений по питанию.';
			case 'catering_wird_geladen': return 'Питание загружается...';
			case 'error_loading_catering': return 'Ошибка загрузки питания.';
			case 'no_cleaning_assignments_found': return 'Нет назначений по уборке.';
			case 'you_have_no_cleaning_assignment': return 'У вас нет назначений по уборке';
			case 'your_cleaning_assignment': return 'Ваше назначение по уборке:';
			case 'cleaning_assignments_are_loading': return 'Назначения по уборке загружаются...';
			case 'error_loading_cleaning_data': return 'Ошибка загрузки данных по уборке.';
			case 'this_email_is_already_registered': return 'Этот email уже зарегистрирован.';
			case 'password_is_too_weak_please_use_at_least_6_characters': return 'Пароль слишком слабый. Пожалуйста, используйте не менее 6 символов.';
			case 'please_enter_a_valid_email_address': return 'Пожалуйста, введите действительный email адрес.';
			case 'registration_is_currently_disabled': return 'Регистрация в настоящее время отключена.';
			case 'no_internet_connection_please_check_your_network_and_try_again': return 'Нет интернет-соединения. Проверьте сеть и попробуйте снова.';
			case 'registration_failed': return 'Регистрация не удалась.';
			case 'registration_failed_please_try_again': return 'Регистрация не удалась. Пожалуйста, попробуйте снова.';
			case 'please_wait': return 'Пожалуйста, подождите...';
			case 'already_have_an_account_login': return 'Уже есть аккаунт? Войти';
			case 'don_t_have_an_account_register': return 'Нет аккаунта? Зарегистрироваться';
			case 'first_name': return 'Имя';
			case 'last_name': return 'Фамилия';
			case 'email': return 'Email';
			case 'password': return 'Пароль';
			case 'hide_password': return 'Скрыть пароль';
			case 'show_password': return 'Показать пароль';
			case 'confirm_password': return 'Подтвердить пароль';
			case 'select_place': return 'Выбрать место';
			case 'clear_selection': return 'Очистить выбор';
			case 'about': return 'О приложении';
			case 'welcome_to_faunty_2_0': return 'Добро пожаловать в Faunty 2.0';
			case 'faunty_is_your_modern_management_app_designed_to_simplify_daily_organization_and_communication_for_teams_communities_and_organizations_built_with_a_focus_on_usability_security_and_beautiful_design_faunty_helps_you_stay_connected_and_productive': return 'Faunty — это современное приложение для управления, созданное для упрощения ежедневной организации и коммуникации для команд, сообществ и организаций. С акцентом на удобство, безопасность и красивый дизайн Faunty помогает оставаться на связи и быть продуктивным.';
			case 'features': return 'Функции';
			case 'team_community_management': return 'Управление командой и сообществом';
			case 'weekly_program_assignments': return 'Еженедельная программа и назначения';
			case 'catering_cleaning_schedules': return 'Графики питания и уборки';
			case 'secure_authentication': return 'Безопасная аутентификация';
			case 'custom_notifications': return 'Пользовательские уведомления';
			case 'responsive_mobile_friendly': return 'Адаптивный и мобильный интерфейс';
			case 'about_the_project': return 'О проекте';
			case 'faunty_2_0_is_built_with_flutter_and_firebase_ensuring_fast_performance_and_real_time_updates_our_mission_is_to_empower_users_with_tools_that_make_everyday_management_effortless_and_enjoyable': return 'Faunty 2.0 создан на Flutter и Firebase, обеспечивая высокую производительность и обновления в реальном времени. Наша миссия — дать пользователям инструменты для легкого и приятного управления каждый день.';
			case 'thank_you_for_using_faunty': return 'Спасибо, что используете Faunty!';
			case 'for_feedback_or_support_contact_us_at_talebelergfc_gmail_com': return 'Для обратной связи или поддержки пишите на talebelergfc@gmail.com';
			case 'account': return 'Аккаунт';
			case 'no_user_is_currently_signed_in': return 'В настоящее время никто не вошел в систему.';
			case 'account_details': return 'Детали аккаунта';
			case 'change_password': return 'Сменить пароль';
			case 'new_password': return 'Новый пароль';
			case 'save_password': return 'Сохранить пароль';
			case 'please_enter_a_new_password': return 'Пожалуйста, введите новый пароль.';
			case 'password_changed_successfully': return 'Пароль успешно изменен!';
			case 're_authentication_required': return 'Требуется повторная аутентификация';
			case 'for_security_reasons_please_log_in_again_to_change_your_password_you_will_be_redirected_to_the_login_screen': return 'По соображениям безопасности войдите снова, чтобы изменить пароль. Вы будете перенаправлены на экран входа.';
			case 'created': return 'Создано';
			case 'last_sign_in': return 'Последний вход';
			case 'users': return 'Пользователи';
			case 'active': return 'Активный';
			case 'statistics': return 'Статистика';
			case 'backup_and_restore': return 'Резервное копирование и восстановление';
			case 'settings': return 'Настройки';
			case 'no_user_loaded': return 'Пользователь не загружен.';
			case 'edit_name': return 'Редактировать имя';
			case 'failed_to_update_name': return 'Не удалось обновить имя: ';
			case 'organisation': return 'Организация';
			case 'save_as_template': return 'Сохранить как шаблон';
			case 'select_template_to_override': return 'Выберите шаблон для перезаписи';
			case 'template_name': return 'Название шаблона';
			case 'kOverride': return 'Перезаписать';
			case 'select_a_template': return 'Выберите шаблон';
			case 'no_templates_found': return 'Шаблоны не найдены';
			case 'delete_template': return 'Удалить шаблон';
			case 'close': return 'Закрыть';
			case 'add_new_event': return 'Добавить новое событие';
			case 'edit_event': return 'Редактировать событие';
			case 'select_start_time': return 'Выбрать время начала';
			case 'select_end_time': return 'Выбрать время окончания';
			case 'save_and_go_back': return 'Сохранить и вернуться';
			case 'no_program_entries_for_this_week': return 'Нет записей программы на эту неделю!';
			case 'tap_the_edit_button_below_to_add_a_program_for_the_week': return 'Нажмите кнопку редактирования ниже, чтобы добавить программу на неделю.';
			case 'edit_program': return 'Редактировать программу';
			default: return null;
		}
	}
}

