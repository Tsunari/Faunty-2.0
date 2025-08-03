import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../firestore/program_firestore_service.dart';
import 'user_provider.dart';

final programFirestoreServiceProvider = Provider<ProgramFirestoreService>((ref) {
  final user = ref.watch(userProvider);
  if (user == null) {
    throw Exception('User must be loaded before using ProgramFirestoreService');
  }
  return ProgramFirestoreService(user);
});

final weekProgramProvider = StreamProvider<Map<String, List<Map<String, String>>>>((ref) {
  final service = ref.watch(programFirestoreServiceProvider);
  return service.watchWeekProgram();
});
