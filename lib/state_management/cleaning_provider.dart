
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../firestore/cleaning_firestore_service.dart';

final cleaningFirestoreServiceProvider =
    Provider<CleaningFirestoreService>((ref) => CleaningFirestoreService());

/// Provides the full cleaning data map (places and assignments)
final cleaningDataProvider = StreamProvider<Map<String, dynamic>>((ref) {
  final service = ref.watch(cleaningFirestoreServiceProvider);
  return service.watchCleaning();
});

/// Provides a list of places (with id, name, assignees)
final cleaningPlacesProvider = Provider<List<MapEntry<String, dynamic>>>((ref) {
  final dataAsync = ref.watch(cleaningDataProvider);
  return dataAsync.maybeWhen(
    data: (data) => data.entries
        .map((e) => MapEntry(e.key, e.value))
        .toList(),
    orElse: () => [],
  );
});
