import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../firestore/user_firestore_service.dart';
import '../models/user_entity.dart';

class UserNotifier extends StateNotifier<UserEntity?> {
  final UserFirestoreService _firestoreService = UserFirestoreService();

  UserNotifier() : super(null);

  Future<void> loadUser(UserEntity user) async {
    state = await _firestoreService.getUser(user);
  }

  Future<void> updateUser(UserEntity user) async {
    await _firestoreService.updateUser(user);
    await loadUser(user);
  }

  Future<void> createUser(UserEntity user) async {
    await _firestoreService.createUser(user);
    await loadUser(user);
  }

  Future<void> deleteUser(UserEntity user) async {
    await _firestoreService.deleteUser(user);
    state = null;
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserEntity?>(
  (ref) => UserNotifier(),
);
