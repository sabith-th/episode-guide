const String getSeriesEpisodes = r'''
  query SeriesEpisodes($id: Int!) {
    seriesEpisodes(id: $id) {
      id
      name
      aired
      seasonNumber
      number
      overview
      runtime
      image
    }
  }
''';
