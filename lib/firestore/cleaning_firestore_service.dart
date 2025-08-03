

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class CleaningFirestoreService {
  final _docRef = FirebaseFirestore.instance.collection('cleaning').doc('data');

  /// Watches the cleaning places and assignments structure:
  /// { places: { placeId: { name: String, assignees: [userId, ...] }, ... } }
  Stream<Map<String, dynamic>> watchCleaning() {
    return _docRef.snapshots().map((snapshot) {
      final data = snapshot.data();
      if (data == null || data['places'] == null) return <String, dynamic>{};
      return Map<String, dynamic>.from(data['places'] as Map);
    });
  }

  /// Sets the entire places map (overwrites all places and assignments)
  Future<void> setCleaning(Map<String, dynamic> places) async {
    await _docRef.set({'places': places});
  }

  /// Adds a new place with a generated id
  Future<String> addPlace(String name) async {
    final id = const Uuid().v4();
    final snapshot = await _docRef.get();
    final data = snapshot.data() ?? {};
    final places = Map<String, dynamic>.from(data['places'] ?? {});
    places[id] = {'name': name, 'assignees': <String>[]};
    await _docRef.set({'places': places});
    return id;
  }

  /// Deletes a place by id
  Future<void> deletePlace(String placeId) async {
    final snapshot = await _docRef.get();
    final data = snapshot.data() ?? {};
    final places = Map<String, dynamic>.from(data['places'] ?? {});
    places.remove(placeId);
    await _docRef.set({'places': places});
  }

  /// Updates a place's name
  Future<void> updatePlace(String placeId, String newName) async {
    final snapshot = await _docRef.get();
    final data = snapshot.data() ?? {};
    final places = Map<String, dynamic>.from(data['places'] ?? {});
    if (places[placeId] != null) {
      places[placeId]['name'] = newName;
      await _docRef.set({'places': places});
    }
  }

  /// Assigns users to a place (overwrites assignees for that place)
  Future<void> setAssignees(String placeId, List<String> userIds) async {
    final snapshot = await _docRef.get();
    final data = snapshot.data() ?? {};
    final places = Map<String, dynamic>.from(data['places'] ?? {});
    if (places[placeId] != null) {
      places[placeId]['assignees'] = userIds;
      await _docRef.set({'places': places});
    }
  }

  /// Removes a user from all places
  Future<void> removeUserFromAllPlaces(String userId) async {
    final snapshot = await _docRef.get();
    final data = snapshot.data() ?? {};
    final places = Map<String, dynamic>.from(data['places'] ?? {});
    for (final place in places.values) {
      final assignees = List<String>.from(place['assignees'] ?? []);
      assignees.remove(userId);
      place['assignees'] = assignees;
    }
    await _docRef.set({'places': places});
  }
}
