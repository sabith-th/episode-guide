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
