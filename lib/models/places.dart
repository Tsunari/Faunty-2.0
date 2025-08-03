enum Place { 
  munihFatih, neufahrn, augsburg, neuUlm, stuttgart,
  nurnberg, ehrenfeld, stolberg, mannheim, sindelfingen, 
  berlin, hamburg, dortmund, darmstadt, oberhausen
  }

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
        // Add other cases as needed
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
      case 'Nürnberg':
        return Place.nurnberg;
      case 'Ehrenfeld':
        return Place.ehrenfeld;
      case 'Stolberg':
        return Place.stolberg;
      case 'Mannheim':
        return Place.mannheim;
      case 'Sindelfingen':
        return Place.sindelfingen;
      case 'Berlin':
        return Place.berlin;
      case 'Hamburg':
        return Place.hamburg;
      case 'Dortmund':
        return Place.dortmund;
      case 'Darmstadt':
        return Place.darmstadt;
      case 'Oberhausen':
        return Place.oberhausen;
      default:
        return Place.munihFatih;
    }
  }
}
