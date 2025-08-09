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
class TranslationsTr implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsTr({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.tr,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <tr>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	late final TranslationsTr _root = this; // ignore: unused_field

	@override 
	TranslationsTr $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsTr(meta: meta ?? this.$meta);

	// Translations
	@override String get more => 'Daha';
	@override String get Mo => 'Pzt';
	@override String get Tue => 'Sal';
	@override String get Wed => 'Çar';
	@override String get Thu => 'Per';
	@override String get Fr => 'Cum';
	@override String get Sat => 'Cmt';
	@override String get Sun => 'Paz';
	@override String get registration_mode => 'Kayıt Modu';
	@override String get inactive => 'Aktif Değil';
	@override String get enable_or_disable_registration => 'Kaydı etkinleştir veya devre dışı bırak';
	@override String get language => 'Dil';
	@override String get help => 'Yardım';
	@override String get Faunty => 'Faunty';
	@override String get Register => 'Kayıt Ol';
	@override String get Login => 'Giriş Yap';
	@override String get monday => 'Pazartesi';
	@override String get tuesday => 'Salı';
	@override String get wednesday => 'Çarşamba';
	@override String get thursday => 'Perşembe';
	@override String get friday => 'Cuma';
	@override String get saturday => 'Cumartesi';
	@override String get sunday => 'Pazar';
	@override String get catering => 'Yemek';
	@override String get no_catering_assignments_yet => 'Henüz yemek görevlendirmesi yok!';
	@override String get tap_the_edit_button_below_to_assign_users_to_meals_for_the_week => 'Hafta için kullanıcılara yemek görevi atamak için aşağıdaki düzenle düğmesine dokunun.';
	@override String get edit => 'Düzenle';
	@override String get cleaning => 'Temizlik';
	@override String get place => 'Yer';
	@override String get assignees => 'Atananlar';
	@override String get no_cleaning_places_yet => 'Henüz temizlik yeri yok!';
	@override String get no_users_assigned_to_any_places => 'Hiçbir yere kullanıcı atanmadı.';
	@override String get tap_below_to_create_your_first_place_and_start_assigning_users => 'İlk yerinizi oluşturmak ve kullanıcılara atama yapmak için aşağıya dokunun.';
	@override String get assign_users_to_your_existing_places_using_the_action_button_below => 'Mevcut yerlerinize kullanıcı atamak için aşağıdaki işlem düğmesini kullanın.';
	@override String get create_place => 'Yer Oluştur';
	@override String get place_name => 'Yer adı';
	@override String get cancel => 'İptal';
	@override String get create => 'Oluştur';
	@override String get no_users_assigned => 'Atanan kullanıcı yok';
	@override String get add_place => 'Yer Ekle';
	@override String get add => 'Ekle';
	@override String get edit_place => 'Yeri Düzenle';
	@override String get save => 'Kaydet';
	@override String get edit_assignments => 'Atamaları Düzenle';
	@override String get no_places_yet => 'Henüz yer yok.';
	@override String get delete_place => 'Yeri Sil';
	@override String get waiting_for_userentity_homepage_was_built_without_a_loaded_user => 'Kullanıcı yüklenmeden ana sayfa oluşturuldu... Kullanıcı bekleniyor.';
	@override String get home => 'Ana Sayfa';
	@override String get program => 'Program';
	@override String get no_program_entries_found_for_this_week => 'Bu hafta için program girişi bulunamadı.';
	@override String get error_loading_program_placeholder => 'Program yüklenirken hata: {placeholder}';
	@override String get today => 'Bugün';
	@override String get your_next_catering_assignment => 'Bir sonraki yemek göreviniz:';
	@override String get no_upcoming_catering_assignment_found => 'Yaklaşan yemek görevi bulunamadı.';
	@override String get catering_wird_geladen => 'Yemek yükleniyor...';
	@override String get error_loading_catering => 'Yemek yüklenirken hata.';
	@override String get no_cleaning_assignments_found => 'Temizlik görevi bulunamadı.';
	@override String get you_have_no_cleaning_assignment => 'Temizlik göreviniz yok';
	@override String get your_cleaning_assignment => 'Temizlik göreviniz:';
	@override String get cleaning_assignments_are_loading => 'Temizlik görevleri yükleniyor...';
	@override String get error_loading_cleaning_data => 'Temizlik verisi yüklenirken hata.';
	@override String get this_email_is_already_registered => 'Bu e-posta zaten kayıtlı.';
	@override String get password_is_too_weak_please_use_at_least_6_characters => 'Şifre çok zayıf. Lütfen en az 6 karakter kullanın.';
	@override String get please_enter_a_valid_email_address => 'Lütfen geçerli bir e-posta adresi girin.';
	@override String get registration_is_currently_disabled => 'Kayıt şu anda devre dışı.';
	@override String get no_internet_connection_please_check_your_network_and_try_again => 'İnternet bağlantısı yok. Lütfen ağınızı kontrol edin ve tekrar deneyin.';
	@override String get registration_failed => 'Kayıt başarısız.';
	@override String get registration_failed_please_try_again => 'Kayıt başarısız. Lütfen tekrar deneyin.';
	@override String get please_wait => 'Lütfen bekleyin...';
	@override String get already_have_an_account_login => 'Zaten hesabınız var mı? Giriş yapın';
	@override String get don_t_have_an_account_register => 'Hesabınız yok mu? Kayıt olun';
	@override String get first_name => 'Ad';
	@override String get last_name => 'Soyad';
	@override String get email => 'E-posta';
	@override String get password => 'Şifre';
	@override String get hide_password => 'Şifreyi gizle';
	@override String get show_password => 'Şifreyi göster';
	@override String get confirm_password => 'Şifreyi Onayla';
	@override String get select_place => 'Yer Seç';
	@override String get clear_selection => 'Seçimi temizle';
	@override String get about => 'Hakkında';
	@override String get welcome_to_faunty_2_0 => 'Faunty 2.0\'a hoş geldiniz';
	@override String get faunty_is_your_modern_management_app_designed_to_simplify_daily_organization_and_communication_for_teams_communities_and_organizations_built_with_a_focus_on_usability_security_and_beautiful_design_faunty_helps_you_stay_connected_and_productive => 'Faunty, günlük organizasyon ve iletişimi kolaylaştırmak için tasarlanmış modern bir yönetim uygulamasıdır. Kullanılabilirlik, güvenlik ve güzel tasarım odaklı olarak geliştirilen Faunty, bağlı ve üretken kalmanıza yardımcı olur.';
	@override String get features => 'Özellikler';
	@override String get team_community_management => 'Takım & Topluluk Yönetimi';
	@override String get weekly_program_assignments => 'Haftalık Program & Görevler';
	@override String get catering_cleaning_schedules => 'Yemek & Temizlik Takvimleri';
	@override String get secure_authentication => 'Güvenli Kimlik Doğrulama';
	@override String get custom_notifications => 'Özel Bildirimler';
	@override String get responsive_mobile_friendly => 'Duyarlı & Mobil Uyumlu';
	@override String get about_the_project => 'Proje Hakkında';
	@override String get faunty_2_0_is_built_with_flutter_and_firebase_ensuring_fast_performance_and_real_time_updates_our_mission_is_to_empower_users_with_tools_that_make_everyday_management_effortless_and_enjoyable => 'Faunty 2.0, hızlı performans ve gerçek zamanlı güncellemeler sağlayan Flutter ve Firebase ile geliştirilmiştir. Amacımız, günlük yönetimi zahmetsiz ve keyifli hale getiren araçlarla kullanıcıları güçlendirmektir.';
	@override String get thank_you_for_using_faunty => 'Faunty kullandığınız için teşekkürler!';
	@override String get for_feedback_or_support_contact_us_at_talebelergfc_gmail_com => 'Geri bildirim veya destek için talebelergfc@gmail.com adresinden bize ulaşın.';
	@override String get account => 'Hesap';
	@override String get no_user_is_currently_signed_in => 'Şu anda oturum açmış kullanıcı yok.';
	@override String get account_details => 'Hesap Detayları';
	@override String get change_password => 'Şifreyi Değiştir';
	@override String get new_password => 'Yeni Şifre';
	@override String get save_password => 'Şifreyi Kaydet';
	@override String get please_enter_a_new_password => 'Lütfen yeni bir şifre girin.';
	@override String get password_changed_successfully => 'Şifre başarıyla değiştirildi!';
	@override String get re_authentication_required => 'Yeniden Kimlik Doğrulama Gerekli';
	@override String get for_security_reasons_please_log_in_again_to_change_your_password_you_will_be_redirected_to_the_login_screen => 'Güvenlik nedeniyle, şifrenizi değiştirmek için tekrar giriş yapmanız gerekmektedir. Giriş ekranına yönlendirileceksiniz.';
	@override String get created => 'Oluşturuldu';
	@override String get last_sign_in => 'Son Giriş';
	@override String get users => 'Kullanıcılar';
	@override String get active => 'Aktif';
	@override String get statistics => 'İstatistikler';
	@override String get backup_and_restore => 'Yedekleme ve geri yükleme';
	@override String get settings => 'Ayarlar';
	@override String get no_user_loaded => 'Kullanıcı yüklenmedi.';
	@override String get edit_name => 'Adı Düzenle';
	@override String get failed_to_update_name => 'Ad güncellenemedi: ';
	@override String get organisation => 'Organizasyon';
	@override String get save_as_template => 'Şablon olarak kaydet';
	@override String get select_template_to_override => 'Üzerine yazılacak şablonu seçin';
	@override String get template_name => 'Şablon adı';
	@override String get kOverride => 'Üzerine yaz';
	@override String get select_a_template => 'Şablon seç';
	@override String get no_templates_found => 'Şablon bulunamadı';
	@override String get delete_template => 'Şablonu sil';
	@override String get close => 'Kapat';
	@override String get add_new_event => 'Yeni etkinlik ekle';
	@override String get edit_event => 'Etkinliği düzenle';
	@override String get select_start_time => 'Başlangıç saatini seç';
	@override String get select_end_time => 'Bitiş saatini seç';
	@override String get save_and_go_back => 'Kaydet ve geri dön';
	@override String get no_program_entries_for_this_week => 'Bu hafta için program girişi yok!';
	@override String get tap_the_edit_button_below_to_add_a_program_for_the_week => 'Hafta için program eklemek için aşağıdaki düzenle düğmesine dokunun.';
	@override String get edit_program => 'Programı düzenle';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.
extension on TranslationsTr {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'more': return 'Daha';
			case 'Mo': return 'Pzt';
			case 'Tue': return 'Sal';
			case 'Wed': return 'Çar';
			case 'Thu': return 'Per';
			case 'Fr': return 'Cum';
			case 'Sat': return 'Cmt';
			case 'Sun': return 'Paz';
			case 'registration_mode': return 'Kayıt Modu';
			case 'inactive': return 'Aktif Değil';
			case 'enable_or_disable_registration': return 'Kaydı etkinleştir veya devre dışı bırak';
			case 'language': return 'Dil';
			case 'help': return 'Yardım';
			case 'Faunty': return 'Faunty';
			case 'Register': return 'Kayıt Ol';
			case 'Login': return 'Giriş Yap';
			case 'monday': return 'Pazartesi';
			case 'tuesday': return 'Salı';
			case 'wednesday': return 'Çarşamba';
			case 'thursday': return 'Perşembe';
			case 'friday': return 'Cuma';
			case 'saturday': return 'Cumartesi';
			case 'sunday': return 'Pazar';
			case 'catering': return 'Yemek';
			case 'no_catering_assignments_yet': return 'Henüz yemek görevlendirmesi yok!';
			case 'tap_the_edit_button_below_to_assign_users_to_meals_for_the_week': return 'Hafta için kullanıcılara yemek görevi atamak için aşağıdaki düzenle düğmesine dokunun.';
			case 'edit': return 'Düzenle';
			case 'cleaning': return 'Temizlik';
			case 'place': return 'Yer';
			case 'assignees': return 'Atananlar';
			case 'no_cleaning_places_yet': return 'Henüz temizlik yeri yok!';
			case 'no_users_assigned_to_any_places': return 'Hiçbir yere kullanıcı atanmadı.';
			case 'tap_below_to_create_your_first_place_and_start_assigning_users': return 'İlk yerinizi oluşturmak ve kullanıcılara atama yapmak için aşağıya dokunun.';
			case 'assign_users_to_your_existing_places_using_the_action_button_below': return 'Mevcut yerlerinize kullanıcı atamak için aşağıdaki işlem düğmesini kullanın.';
			case 'create_place': return 'Yer Oluştur';
			case 'place_name': return 'Yer adı';
			case 'cancel': return 'İptal';
			case 'create': return 'Oluştur';
			case 'no_users_assigned': return 'Atanan kullanıcı yok';
			case 'add_place': return 'Yer Ekle';
			case 'add': return 'Ekle';
			case 'edit_place': return 'Yeri Düzenle';
			case 'save': return 'Kaydet';
			case 'edit_assignments': return 'Atamaları Düzenle';
			case 'no_places_yet': return 'Henüz yer yok.';
			case 'delete_place': return 'Yeri Sil';
			case 'waiting_for_userentity_homepage_was_built_without_a_loaded_user': return 'Kullanıcı yüklenmeden ana sayfa oluşturuldu... Kullanıcı bekleniyor.';
			case 'home': return 'Ana Sayfa';
			case 'program': return 'Program';
			case 'no_program_entries_found_for_this_week': return 'Bu hafta için program girişi bulunamadı.';
			case 'error_loading_program_placeholder': return 'Program yüklenirken hata: {placeholder}';
			case 'today': return 'Bugün';
			case 'your_next_catering_assignment': return 'Bir sonraki yemek göreviniz:';
			case 'no_upcoming_catering_assignment_found': return 'Yaklaşan yemek görevi bulunamadı.';
			case 'catering_wird_geladen': return 'Yemek yükleniyor...';
			case 'error_loading_catering': return 'Yemek yüklenirken hata.';
			case 'no_cleaning_assignments_found': return 'Temizlik görevi bulunamadı.';
			case 'you_have_no_cleaning_assignment': return 'Temizlik göreviniz yok';
			case 'your_cleaning_assignment': return 'Temizlik göreviniz:';
			case 'cleaning_assignments_are_loading': return 'Temizlik görevleri yükleniyor...';
			case 'error_loading_cleaning_data': return 'Temizlik verisi yüklenirken hata.';
			case 'this_email_is_already_registered': return 'Bu e-posta zaten kayıtlı.';
			case 'password_is_too_weak_please_use_at_least_6_characters': return 'Şifre çok zayıf. Lütfen en az 6 karakter kullanın.';
			case 'please_enter_a_valid_email_address': return 'Lütfen geçerli bir e-posta adresi girin.';
			case 'registration_is_currently_disabled': return 'Kayıt şu anda devre dışı.';
			case 'no_internet_connection_please_check_your_network_and_try_again': return 'İnternet bağlantısı yok. Lütfen ağınızı kontrol edin ve tekrar deneyin.';
			case 'registration_failed': return 'Kayıt başarısız.';
			case 'registration_failed_please_try_again': return 'Kayıt başarısız. Lütfen tekrar deneyin.';
			case 'please_wait': return 'Lütfen bekleyin...';
			case 'already_have_an_account_login': return 'Zaten hesabınız var mı? Giriş yapın';
			case 'don_t_have_an_account_register': return 'Hesabınız yok mu? Kayıt olun';
			case 'first_name': return 'Ad';
			case 'last_name': return 'Soyad';
			case 'email': return 'E-posta';
			case 'password': return 'Şifre';
			case 'hide_password': return 'Şifreyi gizle';
			case 'show_password': return 'Şifreyi göster';
			case 'confirm_password': return 'Şifreyi Onayla';
			case 'select_place': return 'Yer Seç';
			case 'clear_selection': return 'Seçimi temizle';
			case 'about': return 'Hakkında';
			case 'welcome_to_faunty_2_0': return 'Faunty 2.0\'a hoş geldiniz';
			case 'faunty_is_your_modern_management_app_designed_to_simplify_daily_organization_and_communication_for_teams_communities_and_organizations_built_with_a_focus_on_usability_security_and_beautiful_design_faunty_helps_you_stay_connected_and_productive': return 'Faunty, günlük organizasyon ve iletişimi kolaylaştırmak için tasarlanmış modern bir yönetim uygulamasıdır. Kullanılabilirlik, güvenlik ve güzel tasarım odaklı olarak geliştirilen Faunty, bağlı ve üretken kalmanıza yardımcı olur.';
			case 'features': return 'Özellikler';
			case 'team_community_management': return 'Takım & Topluluk Yönetimi';
			case 'weekly_program_assignments': return 'Haftalık Program & Görevler';
			case 'catering_cleaning_schedules': return 'Yemek & Temizlik Takvimleri';
			case 'secure_authentication': return 'Güvenli Kimlik Doğrulama';
			case 'custom_notifications': return 'Özel Bildirimler';
			case 'responsive_mobile_friendly': return 'Duyarlı & Mobil Uyumlu';
			case 'about_the_project': return 'Proje Hakkında';
			case 'faunty_2_0_is_built_with_flutter_and_firebase_ensuring_fast_performance_and_real_time_updates_our_mission_is_to_empower_users_with_tools_that_make_everyday_management_effortless_and_enjoyable': return 'Faunty 2.0, hızlı performans ve gerçek zamanlı güncellemeler sağlayan Flutter ve Firebase ile geliştirilmiştir. Amacımız, günlük yönetimi zahmetsiz ve keyifli hale getiren araçlarla kullanıcıları güçlendirmektir.';
			case 'thank_you_for_using_faunty': return 'Faunty kullandığınız için teşekkürler!';
			case 'for_feedback_or_support_contact_us_at_talebelergfc_gmail_com': return 'Geri bildirim veya destek için talebelergfc@gmail.com adresinden bize ulaşın.';
			case 'account': return 'Hesap';
			case 'no_user_is_currently_signed_in': return 'Şu anda oturum açmış kullanıcı yok.';
			case 'account_details': return 'Hesap Detayları';
			case 'change_password': return 'Şifreyi Değiştir';
			case 'new_password': return 'Yeni Şifre';
			case 'save_password': return 'Şifreyi Kaydet';
			case 'please_enter_a_new_password': return 'Lütfen yeni bir şifre girin.';
			case 'password_changed_successfully': return 'Şifre başarıyla değiştirildi!';
			case 're_authentication_required': return 'Yeniden Kimlik Doğrulama Gerekli';
			case 'for_security_reasons_please_log_in_again_to_change_your_password_you_will_be_redirected_to_the_login_screen': return 'Güvenlik nedeniyle, şifrenizi değiştirmek için tekrar giriş yapmanız gerekmektedir. Giriş ekranına yönlendirileceksiniz.';
			case 'created': return 'Oluşturuldu';
			case 'last_sign_in': return 'Son Giriş';
			case 'users': return 'Kullanıcılar';
			case 'active': return 'Aktif';
			case 'statistics': return 'İstatistikler';
			case 'backup_and_restore': return 'Yedekleme ve geri yükleme';
			case 'settings': return 'Ayarlar';
			case 'no_user_loaded': return 'Kullanıcı yüklenmedi.';
			case 'edit_name': return 'Adı Düzenle';
			case 'failed_to_update_name': return 'Ad güncellenemedi: ';
			case 'organisation': return 'Organizasyon';
			case 'save_as_template': return 'Şablon olarak kaydet';
			case 'select_template_to_override': return 'Üzerine yazılacak şablonu seçin';
			case 'template_name': return 'Şablon adı';
			case 'kOverride': return 'Üzerine yaz';
			case 'select_a_template': return 'Şablon seç';
			case 'no_templates_found': return 'Şablon bulunamadı';
			case 'delete_template': return 'Şablonu sil';
			case 'close': return 'Kapat';
			case 'add_new_event': return 'Yeni etkinlik ekle';
			case 'edit_event': return 'Etkinliği düzenle';
			case 'select_start_time': return 'Başlangıç saatini seç';
			case 'select_end_time': return 'Bitiş saatini seç';
			case 'save_and_go_back': return 'Kaydet ve geri dön';
			case 'no_program_entries_for_this_week': return 'Bu hafta için program girişi yok!';
			case 'tap_the_edit_button_below_to_add_a_program_for_the_week': return 'Hafta için program eklemek için aşağıdaki düzenle düğmesine dokunun.';
			case 'edit_program': return 'Programı düzenle';
			default: return null;
		}
	}
}

