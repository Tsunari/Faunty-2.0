enum Place { 
  munihFatih, neufahrn, augsburg, neuUlm, stuttgart,
  nurnberg, ehrenfeld, stolberg, mannheim, sindelfingen, 
  berlin, hamburg, dortmund, darmstadt, oberhausen
  }

extension PlaceExtension on Place {
  /// Firestore-safe name (enum identifier)
  String get name => toString().split('.').last;

  /// User-friendly display name
  String get displayName {
    switch (this) {
      case Place.munihFatih:
        return 'Münih Fatih';
      case Place.neufahrn:
        return 'Neufahrn';
      case Place.augsburg:
        return 'Augsburg';
      case Place.neuUlm:
        return 'Neu Ulm';
      case Place.stuttgart:
        return 'Stuttgart';
      case Place.nurnberg:
        return 'Nürnberg';
      case Place.ehrenfeld:
        return 'Ehrenfeld';
      case Place.stolberg:
        return 'Stolberg';
      case Place.mannheim:
        return 'Mannheim';
      case Place.sindelfingen:
        return 'Sindelfingen';
      case Place.berlin:
        return 'Berlin';
      case Place.hamburg:
        return 'Hamburg';
      case Place.dortmund:
        return 'Dortmund';
      case Place.darmstadt:
        return 'Darmstadt';
      case Place.oberhausen:
        return 'Oberhausen';
    }
  }

  static Place fromString(String value) {
    // Try to match by enum name first
    for (final place in Place.values) {
      if (place.name == value) return place;
    }
    // Then try to match by displayName
    for (final place in Place.values) {
      if (place.displayName == value) return place;
    }
    return Place.munihFatih;
  }
}
