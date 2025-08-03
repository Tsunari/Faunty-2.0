import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../firestore/user_firestore_service.dart';
import '../models/user_entity.dart';

import '../models/places.dart';
import '../models/user_roles.dart';

class UserNotifier extends StateNotifier<UserEntity?> {
  final UserFirestoreService _firestoreService = UserFirestoreService();

  UserNotifier() : super(null);

  Future<bool> loadUser({required String uid, required Place place}) async {
    final user = await _firestoreService.getUserByUidAndPlace(uid: uid, place: place);
    state = user;
    return user != null;
  }

  Future<void> updateUser(UserEntity user) async {
    await _firestoreService.updateUser(user);
    await loadUser(uid: user.uid, place: user.place);
  }

  Future<bool> createUser({
    required String uid,
    required String email,
    required Place place,
    String? firstName,
    String? lastName,
  }) async {
    // Always create as UserRole.user for registration
    final user = UserEntity(
      uid: uid,
      email: email,
      role: UserRole.user,
      place: place,
    );
    await _firestoreService.createUser(user, firstName: firstName, lastName: lastName);
    return await loadUser(uid: uid, place: place);
  }

  Future<void> deleteUser(UserEntity user) async {
    await _firestoreService.deleteUser(user);
    state = null;
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserEntity?>(
  (ref) => UserNotifier(),
);
