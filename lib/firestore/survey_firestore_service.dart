import 'package:cloud_firestore/cloud_firestore.dart';

class SurveyFirestoreService {
  final String placeId;
  SurveyFirestoreService(this.placeId);

  CollectionReference get _surveyCollection => FirebaseFirestore.instance
      .collection('places')
      .doc(placeId)
      .collection('surveys');

  /// Stream of all surveys for a place (real-time updates)
  Stream<List<Map<String, dynamic>>> surveyStream() {
    return _surveyCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id,
          ...data,
        };
      }).toList();
    });
  }

  /// Add a new survey
  Future<void> addSurvey(Map<String, dynamic> survey) async {
    await _surveyCollection.add(survey);
  }

  /// Update an existing survey
  Future<void> updateSurvey(String surveyId, Map<String, dynamic> data) async {
    await _surveyCollection.doc(surveyId).update(data);
  }

  /// Increment vote for an option
  Future<void> incrementVote(String surveyId, String optionValue, {required String userId}) async {
    final docRef = _surveyCollection.doc(surveyId);
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      final data = snapshot.data() as Map<String, dynamic>?;
      if (data == null) return;
      final options = List<Map<String, dynamic>>.from(data['options'] ?? []);
      for (var option in options) {
        if (option['value'] == optionValue) {
          option['voteCount'] = (option['voteCount'] ?? 0) + 1;
          final users = List<String>.from(option['users'] ?? []);
          if (!users.contains(userId)) users.add(userId);
          option['users'] = users;
        }
      }
      transaction.update(docRef, {'options': options});
    });
  }

  /// Decrement vote for an option
  Future<void> decrementVote(String surveyId, String optionValue, {required String userId}) async {
    final docRef = _surveyCollection.doc(surveyId);
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      final data = snapshot.data() as Map<String, dynamic>?;
      if (data == null) return;
      final options = List<Map<String, dynamic>>.from(data['options'] ?? []);
      for (var option in options) {
        if (option['value'] == optionValue) {
          option['voteCount'] = ((option['voteCount'] ?? 0) - 1).clamp(0, double.infinity);
          final users = List<String>.from(option['users'] ?? []);
          users.remove(userId);
          option['users'] = users;
        }
      }
      transaction.update(docRef, {'options': options});
    });
  }

  /// Select an option (single choice)
  Future<void> selectOption(String surveyId, String optionValue, {required String userId}) async {
    final docRef = _surveyCollection.doc(surveyId);
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      final data = snapshot.data() as Map<String, dynamic>?;
      if (data == null) return;
      final options = List<Map<String, dynamic>>.from(data['options'] ?? []);
      // Remove user from all options first
      for (var option in options) {
        final users = List<String>.from(option['users'] ?? []);
        users.remove(userId);
        option['users'] = users;
        if (option['value'] == optionValue) {
          option['voteCount'] = (option['voteCount'] ?? 0) + 1;
          if (!users.contains(userId)) users.add(userId);
        }
      }
      transaction.update(docRef, {'options': options});
    });
  }
}
