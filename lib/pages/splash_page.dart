import 'package:faunty/helper/logging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../models/places.dart';
import '../state_management/user_provider.dart';
import '../models/user_entity.dart';
import '../state_management/user_list_provider.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  bool _navigated = false;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final allUsersAsync = ref.watch(allUsersProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_navigated) return;
      if (user == null) {
        _navigated = true;
        Navigator.of(context).pushReplacementNamed('/login');
        return;
      }
      if (allUsersAsync is AsyncData<List<UserEntity>>) {
        final allUsers = allUsersAsync.value;
        final userEntity = allUsers.where((u) => u.uid == user.uid).toList();
        final placeId = userEntity.isNotEmpty ? userEntity.first.placeId : null;
        if (placeId != null && placeId.isNotEmpty) {
          final success = await ref.read(userProvider.notifier).loadUser(uid: user.uid);
          if (success) {
            _navigated = true;
            printInfo("UserEntity in SplashPage: ${userEntity.first.toMap()}");
            if (context.mounted) {
              Navigator.of(context).pushReplacementNamed('/home');
            }
            return;
          }
        }
        // If failed, go to login
        _navigated = true;
        if (context.mounted) {
          Navigator.of(context).pushReplacementNamed('/login');
        }
      }
      // If loading or error, do nothing (show progress)
    });

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
