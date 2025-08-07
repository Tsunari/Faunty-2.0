import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_entity.dart';

// StreamProvider for real-time user updates based on authStateChanges
final userProvider = StreamProvider<UserEntity?>((ref) {
  return FirebaseAuth.instance.authStateChanges().asyncMap((firebaseUser) async {
    if (firebaseUser == null) return null;
    final doc = await FirebaseFirestore.instance
        .collection('user_list')
        .doc(firebaseUser.uid)
        .get();
    return doc.exists ? UserEntity.fromMap(doc.data()!) : null;
  });
});
