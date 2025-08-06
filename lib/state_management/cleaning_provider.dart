
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../firestore/cleaning_firestore_service.dart';
import 'user_provider.dart';

final cleaningFirestoreServiceProvider = Provider<CleaningFirestoreService>((ref) {
  final user = ref.watch(userProvider);
  if (user == null) {
    throw Exception('User must be loaded before using CleaningFirestoreService');
  }
  return CleaningFirestoreService(user);
});

/// Provides the full cleaning data map (places and assignments)
final cleaningDataProvider = StreamProvider<Map<String, dynamic>>((ref) {
  final service = ref.watch(cleaningFirestoreServiceProvider);
  return service.watchCleaning();
});

// Checks if all places are empty (no users assigned)
final placesEmptyProvider = Provider<bool>((ref) {
  final cleaningData = ref.watch(cleaningDataProvider).maybeWhen(
    data: (data) => data,
    orElse: () => {},
  );
  if (cleaningData.isEmpty) return true;
  final places = cleaningData.entries.toList();
  return places.every((e) {
    final placeData = e.value as Map<String, dynamic>;
    final assigned = (placeData['assignees'] as List?)?.cast<String>() ?? [];
    return assigned.isEmpty;
  });
});