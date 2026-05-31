const String getEpisodeDetails = r'''
  query EpisodeDetails($id: Int!) {
    episode(id: $id) {
      id
      finaleType
      seasonName
      networks {
        id
        name
      }
      studios {
        id
        name
      }
      characters {
        id
        name
        image
        isFeatured
        peopleId
        personImgURL
        personName
        sort
        peopleType
      }
    }
  }
''';
