import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceFirestoreService {
  final String placeId;
  AttendanceFirestoreService(this.placeId);

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

  // Metadata doc to store items and default selection
  DocumentReference<Map<String, dynamic>> get _metaDoc =>
      FirebaseFirestore.instance.collection('places').doc(placeId).collection('attendance').doc('_meta');

  Stream<Map<String, dynamic>> getAttendanceMetaStream() async* {
    await for (final snapshot in _metaDoc.snapshots()) {
      yield snapshot.data() ?? <String, dynamic>{};
    }
  }

  Future<Map<String, dynamic>> getAttendanceMeta() async {
    final snap = await _metaDoc.get();
    return snap.data() ?? <String, dynamic>{};
  }

  Future<void> setAttendanceMeta(Map<String, dynamic> content) async {
    await _metaDoc.set(content);
  }

  /// Atomically toggle presence for a single item field using arrayUnion/arrayRemove.
  /// This keeps writes small and avoids reading/modifying the whole document client-side.
  Future<void> toggleAttendanceItem({
    required String dateId,
    required String itemName,
    required String userId,
    required bool checked,
  }) async {
    final docRef = _attendanceCollection.doc(dateId);
    final presentPath = '$itemName.present';
    final absentPath = '$itemName.absent';
    final writeBatch = FirebaseFirestore.instance.batch();
    if (checked) {
      // add to present, remove from absent
      writeBatch.update(docRef, {presentPath: FieldValue.arrayUnion([userId])});
      writeBatch.update(docRef, {absentPath: FieldValue.arrayRemove([userId])});
    } else {
      writeBatch.update(docRef, {presentPath: FieldValue.arrayRemove([userId])});
      writeBatch.update(docRef, {absentPath: FieldValue.arrayUnion([userId])});
    }
    try {
      await writeBatch.commit();
    } catch (e) {
      // If document doesn't exist yet, create it with the minimal structure
      final initial = <String, dynamic>{
        itemName: {
          'present': checked ? [userId] : <String>[],
          'absent': checked ? <String>[] : [userId],
        }
      };
      await docRef.set(initial, SetOptions(merge: true));
    }
  }
}
