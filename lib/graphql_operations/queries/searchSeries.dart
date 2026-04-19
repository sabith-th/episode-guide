const String searchSeries = r'''
  query SearchSeries($name: String!) {
    searchSeries(name: $name) {
      tvdb_id
      name
      network
      first_air_time
      status
    }
  }
''';
