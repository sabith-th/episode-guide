const String getPerson = r'''
  query Person($id: Int!) {
    person(id: $id) {
      id
      name
      image
      birth
      birthPlace
      death
      characters {
        id
        name
        image
        isFeatured
        seriesId
        movieId
        sort
      }
      awards {
        id
        name
      }
    }
  }
''';
