import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_entity.dart';
import 'user_provider.dart';

final allUsersProvider = StreamProvider<List<UserEntity>>((ref) {
  return FirebaseFirestore.instance
      .collection('user_list')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => UserEntity.fromMap(doc.data()))
          .toList());
});

final usersByCurrentPlaceProvider = StreamProvider<List<UserEntity>>((ref) {
  final userAsync = ref.watch(userProvider);
  final user = userAsync.asData?.value;
  if (user == null) {
    return const Stream<List<UserEntity>>.empty();
  }
  return FirebaseFirestore.instance
      .collection('user_list')
      .where('placeId', isEqualTo: user.placeId)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => UserEntity.fromMap(doc.data()))
          .toList());
});

final usersByRolesProvider = StreamProvider.family<List<UserEntity>, String>((ref, rolesKey) {
  // Use a stable key (basic Type like String, int) for Riverpod family to avoid rebuild issues
  final roleNames = rolesKey.split(',');
  return FirebaseFirestore.instance
      .collection('user_list')
      .where('role', whereIn: roleNames)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => UserEntity.fromMap(doc.data()))
          .toList());
});

final usersByRolesAndPlaceProvider = StreamProvider.family<List<UserEntity>, String>((ref, rolesKey) {
  final userAsync = ref.watch(userProvider);
  final user = userAsync.asData?.value;
  if (user == null) {
    return const Stream<List<UserEntity>>.empty();
  }
  
  final roleNames = rolesKey.split(',');
  return FirebaseFirestore.instance
      .collection('user_list')
      .where('placeId', isEqualTo: user.placeId)
      .where('role', whereIn: roleNames)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => UserEntity.fromMap(doc.data()))
          .toList());
});
