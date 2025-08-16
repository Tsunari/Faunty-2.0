import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceFirestoreService {
  Future<List<String>> getRoster() async {
    final usersSnapshot = await FirebaseFirestore.instance
        .collection('user_list')
        .where('placeId', isEqualTo: placeId)
        .where('role', whereIn: ['Baskan', 'Talebe'])
        .get();
    return usersSnapshot.docs
        .map((d) => (d.data()['uid'] ?? '') as String)
        .where((e) => e.isNotEmpty)
        .toList();
  }
  final String placeId;
  AttendanceFirestoreService(this.placeId);

  CollectionReference<Map<String, dynamic>> get _attendanceCollection =>
      FirebaseFirestore.instance.collection('places').doc(placeId).collection('attendance');

  Stream<Map<String, dynamic>> getAttendanceStream() async* {
    await for (final snapshot in _attendanceCollection.snapshots()) {
      final data = <String, dynamic>{};
      for (final doc in snapshot.docs) {
        data[doc.id] = doc.data();
      }
      // Add roster to the map
      final roster = await getRoster();
      data['roster'] = roster;
      yield data;
    }
  }

  Future<void> setAttendance(String id, Map<String, dynamic> content) async {
    await _attendanceCollection.doc(id).set(content);
  }

  Future<void> deleteAttendance(String id) async {
    await _attendanceCollection.doc(id).delete();
  }
}
