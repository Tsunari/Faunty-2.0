class CleaningAssignment {
  final String id;
  final String place;
  final List<String> assignees;

  CleaningAssignment({
    required this.id,
    required this.place,
    required this.assignees,
  });

  factory CleaningAssignment.fromMap(String id, Map<String, dynamic> map) {
    return CleaningAssignment(
      id: id,
      place: map['place'] as String,
      assignees: List<String>.from(map['assignees'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'place': place,
      'assignees': assignees,
    };
  }
}

class CleaningPlaces {
  final List<String> places;

  CleaningPlaces({required this.places});

  factory CleaningPlaces.fromMap(Map<String, dynamic> map) {
    return CleaningPlaces(
      places: List<String>.from(map['places'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'places': places,
    };
  }
}
