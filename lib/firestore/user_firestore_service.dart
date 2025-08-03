import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faunty/models/places.dart';

import '../models/user_entity.dart';

class UserFirestoreService {
  CollectionReference _usersCollection(Place place) => FirebaseFirestore
      .instance
      .collection('places')
      .doc(place.name)
      .collection('users');

  Future<void> createUser(UserEntity user, {String? firstName, String? lastName}) async {
    final data = user.toMap();
    if (firstName != null) data['firstName'] = firstName;
    if (lastName != null) data['lastName'] = lastName;
    await _usersCollection(user.place).doc(user.uid).set(data);
  }

  Future<UserEntity?> getUserByUidAndPlace({required String uid, required Place place}) async {
    final doc = await _usersCollection(place).doc(uid).get();
    if (doc.exists && doc.data() != null) {
      return UserEntity.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> updateUser(UserEntity user) async {
    await _usersCollection(user.place).doc(user.uid).update(user.toMap());
  }

  Future<void> deleteUser(UserEntity user) async {
    await _usersCollection(user.place).doc(user.uid).delete();
  }
}
