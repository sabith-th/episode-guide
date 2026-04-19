const String getSeriesDetails = r'''
  query SeriesDetails($id: Int!) {
    seriesInfo(id: $id) {
      series {
        id
        name
        image
        overview
        score
        firstAired
        year
        averageRuntime
        status { name }
        genres { name }
        characters {
          personName
          name
          peopleType
          personImgURL
          isFeatured
        }
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
