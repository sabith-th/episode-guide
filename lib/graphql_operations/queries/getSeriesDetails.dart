const String getSeriesDetails = r'''
  query SeriesDetails($id: Int!) {
    seriesInfo(id: $id) {
      series {
        seriesId
        seriesName
        overview
        network
        banner
        airsTime
        airsDayOfWeek
        rating
        siteRating
      }
      actors {
        name
        role
        image
        sortOrder
      }
    }
  }
''';