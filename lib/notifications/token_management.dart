import 'package:cloud_firestore/cloud_firestore.dart';

/// Lightweight model for storing token metadata.
class TokenInfo {
  final String token;
  final String? uid;
  final String platform;
  final DateTime createdAt;
  final DateTime lastSeenAt;

  TokenInfo({
    required this.token,
    this.uid,
    required this.platform,
    required this.createdAt,
    required this.lastSeenAt,
  });

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'platform': platform,
        'createdAt': Timestamp.fromDate(createdAt),
        'lastSeenAt': Timestamp.fromDate(lastSeenAt),
      };
}

class TokenManager {
  static final FirebaseFirestore _fs = FirebaseFirestore.instance;
  static final CollectionReference _tokens = _fs.collection('fcm_tokens');

  /// Save or update token info. Uses token string as document id for O(1) lookup.
  static Future<void> saveToken(TokenInfo info) async {
    final docRef = _tokens.doc(info.token);
    final now = Timestamp.fromDate(DateTime.now().toUtc());
    final map = info.toMap();
    // If document exists, update lastSeenAt and uid if changed. Otherwise create.
    return _fs.runTransaction((tx) async {
      final snap = await tx.get(docRef);
      if (snap.exists) {
        final existing = snap.data() as Map<String, dynamic>;
        final updates = <String, dynamic>{'lastSeenAt': map['lastSeenAt'] ?? now};
        if ((existing['uid'] ?? null) != info.uid && info.uid != null) {
          updates['uid'] = info.uid;
        }
        updates['platform'] = info.platform;
        tx.update(docRef, updates);
      } else {
        final toCreate = {
          ...map,
          'createdAt': map['createdAt'] ?? now,
        };
        tx.set(docRef, toCreate);
      }
    });
  }

  /// Find the latest token doc for a uid (ordered by lastSeenAt).
  static Future<String?> latestTokenForUid(String uid) async {
    final q = await _tokens.where('uid', isEqualTo: uid).orderBy('lastSeenAt', descending: true).limit(1).get();
    if (q.docs.isEmpty) return null;
    return q.docs.first.id;
  }
}
