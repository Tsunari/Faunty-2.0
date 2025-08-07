import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../firestore/globals_firestore_service.dart';
import '../models/user_entity.dart';
import 'user_provider.dart';

final globalsProvider = StateNotifierProvider<GlobalsNotifier, GlobalsState>((ref) {
  final userAsync = ref.watch(userProvider);
  final user = userAsync.asData?.value;
  if (user == null) {
    // Return a dummy notifier that does nothing if user is not loaded yet
    return GlobalsNotifier.nullUser();
  }
  return GlobalsNotifier(user);
});

class GlobalsState {
  final bool registrationMode;
  GlobalsState({required this.registrationMode});

  GlobalsState copyWith({bool? registrationMode}) =>
      GlobalsState(registrationMode: registrationMode ?? this.registrationMode);
}


class GlobalsNotifier extends StateNotifier<GlobalsState> {

  /// Static method to check registrationMode for a given placeId (no user required)
  static Future<bool?> getRegistrationModeForPlace(String placeId) {
    return GlobalsFirestoreService.getRegistrationModeForPlace(placeId);
  }
  final GlobalsFirestoreService? _service;
  final bool _enabled;

  GlobalsNotifier(UserEntity user)
      : _service = GlobalsFirestoreService(user),
        _enabled = true,
        super(GlobalsState(registrationMode: false)) {
    loadGlobals();
  }

  GlobalsNotifier.nullUser()
      : _service = null,
        _enabled = false,
        super(GlobalsState(registrationMode: false));

  Future<void> loadGlobals() async {
    if (!_enabled || _service == null) return;
    final regMode = await _service.getRegistrationMode();
    if (regMode != null) {
      state = state.copyWith(registrationMode: regMode);
    }
  }

  Future<void> setRegistrationMode(bool value) async {
    if (!_enabled || _service == null) return;
    final success = await _service.setRegistrationMode(value);
    if (success) {
      state = state.copyWith(registrationMode: value);
    }
  }
}
