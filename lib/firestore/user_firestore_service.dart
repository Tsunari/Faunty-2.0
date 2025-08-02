import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_entity.dart';

class UserFirestoreService {
  CollectionReference _usersCollection(String place) => FirebaseFirestore
      .instance
      .collection('places')
      .doc(place)
      .collection('users');

  Future<void> createUser(UserEntity user) async {
    await _usersCollection(user.place.name).doc(user.uid).set(user.toMap());
  }

  Future<UserEntity?> getUser(UserEntity user) async {
    final doc = await _usersCollection(user.place.name).doc(user.uid).get();
    if (doc.exists && doc.data() != null) {
      return UserEntity.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> updateUser(UserEntity user) async {
    await _usersCollection(user.place.name).doc(user.uid).update(user.toMap());
  }

  Future<void> deleteUser(UserEntity user) async {
    await _usersCollection(user.place.name).doc(user.uid).delete();
  }
}
