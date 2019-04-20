const String getSeriesDetails = r'''
  query SeriesDetails($id: Int!, $keyType: KeyType!) {
    seriesInfo(id: $id) {
      series {
        id
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
      images(keyType: $keyType) {
        fileName
        resolution
        thumbnail
      }
    }
  }
''';