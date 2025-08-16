import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:faunty/firestore/survey_firestore_service.dart';
import 'package:faunty/state_management/user_provider.dart';
import 'package:faunty/globals.dart';

final surveyFirestoreServiceProvider = Provider.family<SurveyFirestoreService, String>((ref, placeId) {
  return SurveyFirestoreService(placeId);
});

final surveyResponsesMapProvider = StreamProvider.family.autoDispose<Map<dynamic, int>, SurveyProviderArgs>((ref, args) {
  final service = ref.watch(surveyFirestoreServiceProvider(args.placeId));
  return service.responsesMapStream(args.surveyId);
});

final surveyUserSelectionValueProvider = StreamProvider.family.autoDispose<dynamic, SurveyUserSelectionArgs>((ref, args) {
  final service = ref.watch(surveyFirestoreServiceProvider(args.placeId));
  return service.userSelectionValueStream(args.surveyId, args.userId);
});

class SurveyProviderArgs {
  final String placeId;
  final String surveyId;
  SurveyProviderArgs({required this.placeId, required this.surveyId});
}

class SurveyUserSelectionArgs {
  final String placeId;
  final String surveyId;
  final String userId;
  SurveyUserSelectionArgs({required this.placeId, required this.surveyId, required this.userId});
}
