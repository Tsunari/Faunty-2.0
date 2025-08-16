import 'package:cloud_firestore/cloud_firestore.dart';
import '../globals.dart';

class SurveyFirestoreService {
  final String placeId;
  SurveyFirestoreService(this.placeId);

  CollectionReference get _surveyCollection => FirebaseFirestore.instance
      .collection('places')
      .doc(placeId)
      .collection('surveys');

  // Save or update a user's response for a survey
  Future<void> saveResponse({
    required String surveyId,
    required String userId,
    required dynamic optionValue,
  }) async {
    final doc = _surveyCollection.doc(surveyId).collection('responses').doc(userId);
    await doc.set({'optionValue': optionValue}, SetOptions(merge: true));
  }

  // Stream of all responses for a survey, returns a map of value to count
  Stream<Map<dynamic, int>> responsesMapStream(String surveyId) {
    return _surveyCollection.doc(surveyId).collection('responses').snapshots().map((snapshot) {
      final Map<dynamic, int> counts = {};
      for (final doc in snapshot.docs) {
        final value = doc['optionValue'];
        if (value != null) {
          counts[value] = (counts[value] ?? 0) + 1;
        }
      }
      return counts;
    });
  }

  // Get the current user's selected option value for a survey
  Stream<dynamic> userSelectionValueStream(String surveyId, String userId) {
    return _surveyCollection.doc(surveyId).collection('responses').doc(userId).snapshots().map((doc) {
      if (doc.exists) {
        return doc['optionValue'];
      }
      return null;
    });
  }
}
