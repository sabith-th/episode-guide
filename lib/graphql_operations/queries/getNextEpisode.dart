const String getNextEpisode = r'''
  query NextEpisode($id: Int!, $keyType: KeyType!) {
    seriesInfo(id: $id) {
      series {
        id
        seriesName
        airsTime
        network
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
