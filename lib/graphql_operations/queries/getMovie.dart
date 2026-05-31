const String getMovieName = r'''
  query MovieName($id: Int!) {
    movie(id: $id) {
      id
      name
      image
    }
  }
''';

const String getMovieDetails = r'''
  query MovieDetails($id: Int!) {
    movie(id: $id) {
      id
      name
      image
      year
      runtime
      genres {
        id
        name
      }
      status {
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
      }
    }
    movieTranslation(id: $id, language: "eng") {
      overview
    }
  }
''';
