const String searchSeries = r'''
  query SearchSeries($name: String!) {
    searchSeries(name: $name) {
      id
      seriesName
      network
      firstAired
      status
    }
  }
''';
