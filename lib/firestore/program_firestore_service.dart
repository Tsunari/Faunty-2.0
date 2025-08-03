import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_entity.dart';
import '../models/places.dart';

class ProgramFirestoreService {
  final UserEntity user;
  ProgramFirestoreService(this.user);

  DocumentReference get _docRef {
    final placeName = user.place.name;
    return FirebaseFirestore.instance
        .collection('places')
        .doc(placeName)
        .collection('program')
        .doc('weekProgram');
  }

  /// Watches the week program: Map<String, List<Map<String, String>>> (weekday -> list of events)
  Stream<Map<String, List<Map<String, String>>>> watchWeekProgram() {
    return _docRef.snapshots().map((snapshot) {
      final data = snapshot.data() as Map<String, dynamic>?;
      if (data == null || data['weekProgram'] == null) {
        // Default: empty program for all days
        return {
          for (final day in ['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday']) day: <Map<String, String>>[]
        };
      }
      final raw = data['weekProgram'] as Map<String, dynamic>;
      return raw.map((day, events) => MapEntry(
        day,
        (events as List<dynamic>).map<Map<String, String>>((e) => Map<String, String>.from(e as Map)).toList(),
      ));
    });
  }

  /// Sets the entire week program
  Future<void> setWeekProgram(Map<String, List<Map<String, String>>> weekProgram) async {
    // Firestore only allows Map<String, dynamic> and List<Map<String, dynamic>>
    final Map<String, dynamic> serializable = weekProgram.map((k, v) => MapEntry(k, v.map((e) => Map<String, String>.from(e)).toList()));
    await _docRef.set({'weekProgram': serializable});
  }
}
