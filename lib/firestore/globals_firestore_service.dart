import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_entity.dart';

class GlobalsFirestoreService {

  /// Static method to get registrationMode for a given placeId (without user)
  static Future<bool?> getRegistrationModeForPlace(String placeId) async {
    try {
      final doc = FirebaseFirestore.instance
          .collection('places')
          .doc(placeId);
      final snapshot = await doc.get();
      if (snapshot.exists && snapshot.data() != null && snapshot.data()!.containsKey('registrationMode')) {
        return snapshot['registrationMode'] as bool;
      }
      return null;
    } catch (e) {
      print('Error getting registrationMode for place: $e');
      return null;
    }
  }
  final UserEntity user;
  GlobalsFirestoreService(this.user);

  DocumentReference<Map<String, dynamic>> get _placeDoc {
    final placeId = user.placeId;
    return FirebaseFirestore.instance.collection('places').doc(placeId);
  }

  Future<bool> setRegistrationMode(bool value) async {
    try {
      await _placeDoc.set({'registrationMode': value}, SetOptions(merge: true));
      return true;
    } catch (e) {
      print('Error setting registrationMode: $e');
      return false;
    }
  }

  Future<bool?> getRegistrationMode() async {
    try {
      final doc = await _placeDoc.get();
      if (doc.exists && doc.data() != null && doc.data()!.containsKey('registrationMode')) {
        return doc['registrationMode'] as bool;
      }
      return null;
    } catch (e) {
      print('Error getting registrationMode: $e');
      return null;
    }
  }
}
