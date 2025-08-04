import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_entity.dart';

class GlobalsFirestoreService {
  final UserEntity user;
  GlobalsFirestoreService(this.user);

  DocumentReference<Map<String, dynamic>> get _globalsDoc {
    final placeName = user.place.name;
    return FirebaseFirestore.instance.collection('places').doc(placeName).collection('globals').doc('main');
  }

  Future<bool> setRegistrationMode(bool value) async {
    try {
      await _globalsDoc.set({'registrationMode': value}, SetOptions(merge: true));
      return true;
    } catch (e) {
      print('Error setting registrationMode: $e');
      return false;
    }
  }

  Future<bool?> getRegistrationMode() async {
    try {
      final doc = await _globalsDoc.get();
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
