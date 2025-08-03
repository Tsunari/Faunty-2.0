import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/places.dart';
import '../state_management/user_provider.dart';
import '../models/user_entity.dart';
import '../state_management/user_list_provider.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Use allUsersProvider to get user_list from Riverpod
      final allUsersAsync = ref.read(allUsersProvider);
      List<UserEntity> allUsers = [];
      if (allUsersAsync is AsyncData<List<UserEntity>>) {
        allUsers = allUsersAsync.value;
      } else {
        // If not loaded yet, fallback to Firestore (rare, e.g. on cold start)
        final doc = await FirebaseFirestore.instance.collection('user_list').doc(user.uid).get();
        if (doc.exists && doc.data() != null && doc.data()!['place'] != null) {
          allUsers = [UserEntity.fromMap(doc.data()!)];
        }
      }
      final userEntity = allUsers.where((u) => u.uid == user.uid).toList();
      final placeName = userEntity.isNotEmpty ? userEntity.first.place.name : null;
      if (placeName != null) {
        final success = await ref.read(userProvider.notifier).loadUser(uid: user.uid);
        if (success) {
          if (mounted) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pushReplacementNamed('/home');
            });
          }
          return;
        }
      }
      // If failed, go to login
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushReplacementNamed('/login');
        });
      }
    } else {
      // Not logged in
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushReplacementNamed('/login');
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
