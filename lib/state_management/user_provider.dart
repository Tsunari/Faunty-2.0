import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../firestore/user_firestore_service.dart';
import '../models/user_entity.dart';

import '../models/user_roles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

/// StreamProvider for real-time user updates (hybrid approach)
final userProviderStream = StreamProvider<UserEntity?>((ref) {
  final firebaseUser = FirebaseAuth.instance.currentUser;
  if (firebaseUser == null) return Stream<UserEntity?>.value(null);
  return FirebaseFirestore.instance
      .collection('user_list')
      .doc(firebaseUser.uid)
      .snapshots()
      .map((doc) => doc.exists ? UserEntity.fromMap(doc.data()!) : null);
});

final userProvider = StateNotifierProvider<UserNotifier, UserEntity?>(
  (ref) => UserNotifier(),
);
