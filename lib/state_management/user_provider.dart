import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_entity.dart';
import 'package:rxdart/rxdart.dart';

// StreamProvider for real-time user updates based on authStateChanges
final userProvider = StreamProvider<UserEntity?>((ref) {
  return FirebaseAuth.instance.authStateChanges().switchMap((firebaseUser) {
    if (firebaseUser == null) {
      return Stream<UserEntity?>.value(null);
    }
    return FirebaseFirestore.instance
      .collection('user_list')
      .doc(firebaseUser.uid)
      .snapshots()
      .map((doc) => doc.exists ? UserEntity.fromMap(doc.data()!) : null);
  });
});
