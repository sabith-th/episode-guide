const String getNextEpisode = r'''
  query NextEpisode($id: Int!, $keyType: KeyType!) {
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
      episodesSummary {
        nextEpisode {
          airedSeason
          episodeName
          firstAired
          airedEpisodeNumber
        }
      }
      images(keyType: $keyType) {
        fileName
        resolution
        thumbnail
      }
    }
   }
''';
