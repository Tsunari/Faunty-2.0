import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/places.dart';
import '../state_management/user_provider.dart';

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
      // Try to get user's place
      String? placeName;
      try {
        final placeDoc = await FirebaseFirestore.instance.collection('user_places').doc(user.uid).get();
        if (placeDoc.exists && placeDoc.data() != null && placeDoc.data()!['place'] != null) {
          placeName = placeDoc.data()!['place'] as String;
        }
      } catch (_) {}
      if (placeName != null) {
        final success = await ref.read(userProvider.notifier).loadUser(
          uid: user.uid,
          place: PlaceExtension.fromString(placeName),
        );
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
