enum Place { munihFatih, neufahrn, augsburg, neuUlm, stuttgart }

extension PlaceExtension on Place {
  String get name {
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
    }
  }

  static Place fromString(String value) {
    switch (value) {
      case 'Münih Fatih':
        return Place.munihFatih;
      case 'Neufahrn':
        return Place.neufahrn;
      case 'Augsburg':
        return Place.augsburg;
      case 'Neu Ulm':
        return Place.neuUlm;
      case 'Stuttgart':
        return Place.stuttgart;
      default:
        return Place.munihFatih;
    }
  }
}
