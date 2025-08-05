import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../firestore/user_firestore_service.dart';
import '../models/user_entity.dart';

import '../models/user_roles.dart';

class UserNotifier extends StateNotifier<UserEntity?> {
  final UserFirestoreService _firestoreService = UserFirestoreService();

  UserNotifier() : super(null);

  Future<bool> loadUser({required String uid}) async {
    final user = await _firestoreService.getUserByUid(uid: uid);
    state = user;
    return user != null;
  }

  Future<void> updateUser(UserEntity user) async {
    await _firestoreService.updateUser(user);
    await loadUser(uid: user.uid);
  }

  Future<bool> createUser({
    required String uid,
    required String email,
    required String firstName,
    required String lastName,
    required String placeId,
  }) async {
    // Always create as UserRole.user for registration
    final user = UserEntity(
      uid: uid,
      email: email,
      firstName: firstName,
      lastName: lastName,
      role: UserRole.user,
      placeId: placeId,
    );
    await _firestoreService.createUser(user);
    return await loadUser(uid: uid);
  }

  Future<void> deleteUser(UserEntity user) async {
    await _firestoreService.deleteUser(user);
    state = null;
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserEntity?>(
  (ref) => UserNotifier(),
);
