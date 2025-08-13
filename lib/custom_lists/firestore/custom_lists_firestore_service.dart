import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../../models/user_entity.dart';
import '../models/custom_list_model.dart';
import '../models/custom_list_type.dart';

class CustomListsFirestoreService {
  final UserEntity user;
  CustomListsFirestoreService(this.user);

  CollectionReference<Map<String, dynamic>> get _listsCol => FirebaseFirestore
      .instance
      .collection('places')
      .doc(user.placeId)
      .collection('custom_lists');

  DocumentReference<Map<String, dynamic>> _listDoc(String listId) =>
      _listsCol.doc(listId);

  DocumentReference<Map<String, dynamic>> _listDataDoc(String listId) =>
      _listsCol.doc(listId).collection('data').doc('v1');

  CollectionReference<Map<String, dynamic>> _templatesCol(
    CustomListType type,
  ) => FirebaseFirestore.instance
      .collection('places')
      .doc(user.placeId)
      .collection('custom_list_templates')
      .doc(CustomListTypeRegistry.meta[type]!.key)
      .collection('templates');

  Stream<List<CustomListModel>> watchLists() {
    return _listsCol.orderBy('updatedAt', descending: true).snapshots().map((
      snapshot,
    ) {
      return snapshot.docs
          .map((doc) => CustomListModel.fromFirestore(doc.id, doc.data()))
          .toList();
    });
  }

  Future<String> createList({
    required String name,
    required CustomListType type,
    Map<String, dynamic>? settings,
    Map<String, dynamic>? initialContent,
  }) async {
    final id = const Uuid().v4();
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    final model = CustomListModel(
      id: id,
      name: name,
      type: type,
      createdBy: user.uid,
      createdAt: DateTime.fromMillisecondsSinceEpoch(nowMs),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(nowMs),
      isPinnedAsWidget: false,
      settings: settings ?? const {},
    );
    await _listDoc(id).set(model.toMap());
    Map<String, dynamic> content =
        initialContent ??
        CustomListTypeRegistry.meta[type]!.buildDefaultContent();
    // Auto-populate Yoklama roster with place users of roles baskan and talebe
    if (type == CustomListType.yoklama ||
        type == CustomListType.customAttendance) {
      final usersSnapshot = await FirebaseFirestore.instance
          .collection('user_list')
          .where('placeId', isEqualTo: user.placeId)
          .where('role', whereIn: ['Baskan', 'Talebe'])
          .get();
      final roster = usersSnapshot.docs
          .map((d) => (d.data()['uid'] ?? '') as String)
          .where((e) => e.isNotEmpty)
          .toList();
      final mutable = Map<String, dynamic>.from(content);
      mutable['roster'] = roster;
      content = mutable;
    }
    await _listDataDoc(id).set(content);
    return id;
  }

  Future<void> updateListMeta(String listId, Map<String, dynamic> patch) async {
    await _listDoc(
      listId,
    ).update({...patch, 'updatedAt': DateTime.now().millisecondsSinceEpoch});
  }

  Future<void> deleteList(String listId) async {
    // Delete content and metadata (shallow)
    await _listDataDoc(listId).delete();
    await _listDoc(listId).delete();
  }

  Stream<Map<String, dynamic>> watchListContent(String listId) {
    return _listDataDoc(listId).snapshots().map((snapshot) {
      final data = snapshot.data();
      return data == null
          ? <String, dynamic>{}
          : Map<String, dynamic>.from(data);
    });
  }

  Future<void> setListContent(
    String listId,
    Map<String, dynamic> content,
  ) async {
    await _listDataDoc(listId).set(content);
    await updateListMeta(listId, const {}); // bump updatedAt
  }

  Future<void> setTemplate(
    CustomListType type,
    String name,
    Map<String, dynamic> content,
  ) async {
    await _templatesCol(type).doc(name).set(content);
  }

  Future<Map<String, Map<String, dynamic>>> getTemplates(
    CustomListType type,
  ) async {
    final snapshot = await _templatesCol(type).get();
    final Map<String, Map<String, dynamic>> result = {};
    for (final doc in snapshot.docs) {
      result[doc.id] = Map<String, dynamic>.from(doc.data());
    }
    return result;
  }

  Future<void> deleteTemplate(CustomListType type, String name) async {
    await _templatesCol(type).doc(name).delete();
  }
}
