import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/place_model.dart';
import '../firestore/place_firestore_service.dart';

final placeListProvider = FutureProvider<List<PlaceModel>>((ref) async {
  return await PlaceFirestoreService.fetchPlaces();
});

final placeStreamProvider = StreamProvider<List<PlaceModel>>((ref) {
  return PlaceFirestoreService.placesStream();
});
