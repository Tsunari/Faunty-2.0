import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_entity.dart';
// import '../models/places.dart';

class CateringFirestoreService {
  final UserEntity user;
  CateringFirestoreService(this.user);

  DocumentReference get _docRef {
    final placeId = user.placeId;
    return FirebaseFirestore.instance
        .collection('places')
        .doc(placeId)
        .collection('catering')
        .doc('weekPlan');
  }

  Stream<List<List<List<String>>>> watchWeekPlan() {
    return _docRef.snapshots().map((snapshot) {
      final data = snapshot.data() as Map<String, dynamic>?;
      if (data == null || data['weekPlan'] == null) {
        // 7 days, 3 meals, empty
        return List.generate(7, (_) => List.generate(3, (_) => <String>[]));
      }
      final raw = data['weekPlan'] as Map<String, dynamic>;
      // Convert map back to List<List<List<String>>>
      List<List<List<String>>> weekPlan = List.generate(7, (day) => List.generate(3, (meal) {
        final key = '${day}_$meal';
        final users = raw[key];
        if (users is List) {
          return users.map((u) => u.toString()).toList();
        } else {
          return <String>[];
        }
      }));
      return weekPlan;
    });
  }

  /// Sets the entire week plan
  /// weekPlan is List<List<List<String>>> (7 days, 3 meals, users)
  Future<void> setWeekPlan(List<List<List<String>>> weekPlan) async {
    // Convert to Map<String, List<String>>
    final Map<String, List<String>> flat = {};
    for (int day = 0; day < weekPlan.length; day++) {
      for (int meal = 0; meal < weekPlan[day].length; meal++) {
        flat['${day}_$meal'] = List<String>.from(weekPlan[day][meal]);
      }
    }
    await _docRef.set({'weekPlan': flat});
  }
}
