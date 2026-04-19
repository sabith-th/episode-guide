const String getNextEpisode = r'''
  query NextEpisode($id: Int!) {
    seriesInfo(id: $id) {
      series {
        id
        name
        image
        overview
        score
        firstAired
      }
      nextEpisode {
        id
        name
        aired
        seasonNumber
      }
    }
  }
''';
