const String getSeriesName = r'''
  query SeriesName($id: Int!) {
    series(id: $id) {
      id
      name
      image
    }
  }
''';
