import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_entity.dart';

class UserFirestoreService {
  CollectionReference get _usersCollection => FirebaseFirestore.instance.collection('user_list');

  Future<void> createUser(UserEntity user) async {
    final data = user.toMap();
    await _usersCollection.doc(user.uid).set(data);
  }

  Future<UserEntity?> getUserByUid({required String uid}) async {
    final doc = await _usersCollection.doc(uid).get();
    if (doc.exists && doc.data() != null) {
      return UserEntity.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> updateUser(UserEntity user) async {
    await _usersCollection.doc(user.uid).update(user.toMap());
  }

  Future<void> deleteUser(UserEntity user) async {
    await _usersCollection.doc(user.uid).delete();
  }
}
