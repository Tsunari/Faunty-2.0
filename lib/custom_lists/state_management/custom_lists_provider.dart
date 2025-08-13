import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../state_management/user_provider.dart';
import '../firestore/custom_lists_firestore_service.dart';
import '../models/custom_list_model.dart';
import '../models/custom_list_type.dart';

final customListsServiceProvider = Provider<CustomListsFirestoreService>((ref) {
  final userAsync = ref.watch(userProvider);
  final user = userAsync.asData?.value;
  if (user == null) {
    throw Exception(
      'User must be loaded before using CustomListsFirestoreService',
    );
  }
  return CustomListsFirestoreService(user);
});

final customListsProvider = StreamProvider<List<CustomListModel>>((ref) {
  return ref.watch(customListsServiceProvider).watchLists();
});

final customListContentProvider =
    StreamProvider.family<Map<String, dynamic>, String>((ref, listId) {
      return ref.watch(customListsServiceProvider).watchListContent(listId);
    });

final customListTemplatesProvider =
    FutureProvider.family<Map<String, Map<String, dynamic>>, CustomListType>((
      ref,
      type,
    ) {
      return ref.watch(customListsServiceProvider).getTemplates(type);
    });
