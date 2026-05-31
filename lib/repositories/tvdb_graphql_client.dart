import 'package:episode_guide/graphql_operations/queries/queries.dart'
    as queries;
import 'package:episode_guide/models/episode_details.dart';
import 'package:episode_guide/models/movie.dart';
import 'package:episode_guide/models/next_episode.dart';
import 'package:episode_guide/models/person.dart';
import 'package:episode_guide/models/search_series_result.dart';
import 'package:episode_guide/models/series_details.dart';
import 'package:episode_guide/models/series_episode.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class TvdbGraphQLClient {
  final GraphQLClient client;

  TvdbGraphQLClient({required this.client});

  Future<NextEpisode?> getNextEpisode(int id) async {
    final QueryResult result = await client.query(
      QueryOptions(
        document: gql(queries.getNextEpisode),
        variables: <String, dynamic>{'id': id},
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );
    if (result.hasException) {
      throw Exception(result.exception.toString());
    }
    final Map<String, dynamic>? episodeMap = result.data?['seriesInfo'];
    if (episodeMap != null) {
      return NextEpisode.fromJson(episodeMap);
    }
    return null;
  }

  Future<SeriesDetails> getSeriesDetails(int id) async {
    final QueryResult result = await client.query(
      QueryOptions(
        document: gql(queries.getSeriesDetails),
        variables: <String, dynamic>{'id': id},
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );
    if (result.hasException) {
      throw Exception(result.exception.toString());
    }
    final Map<String, dynamic> seriesMap = result.data!['seriesInfo'];
    return SeriesDetails.fromJson(seriesMap);
  }

  Future<List<SeriesEpisode>> getSeriesEpisodes(int id) async {
    final QueryResult result = await client.query(
      QueryOptions(
        document: gql(queries.getSeriesEpisodes),
        variables: <String, dynamic>{'id': id},
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );
    if (result.hasException) {
      throw Exception(result.exception.toString());
    }
    final List<dynamic> list = result.data?['seriesEpisodes'] ?? [];
    return list
        .map((e) => SeriesEpisode.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<({String? name, String? image})?> getSeriesBasicInfo(int id) async {
    final QueryResult result = await client.query(
      QueryOptions(
        document: gql(queries.getSeriesName),
        variables: <String, dynamic>{'id': id},
        fetchPolicy: FetchPolicy.cacheFirst,
      ),
    );
    if (result.hasException) return null;
    final data = result.data?['series'];
    if (data == null) return null;
    return (name: data['name'] as String?, image: data['image'] as String?);
  }

  Future<Person> getPerson(int id) async {
    final QueryResult result = await client.query(
      QueryOptions(
        document: gql(queries.getPerson),
        variables: <String, dynamic>{'id': id},
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );
    if (result.hasException) {
      throw Exception(result.exception.toString());
    }
    final Map<String, dynamic> personMap = result.data!['person'];
    return Person.fromJson(personMap);
  }

  Future<EpisodeDetails> getEpisodeDetails(int id) async {
    final QueryResult result = await client.query(
      QueryOptions(
        document: gql(queries.getEpisodeDetails),
        variables: <String, dynamic>{'id': id},
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );
    if (result.hasException) {
      throw Exception(result.exception.toString());
    }
    final Map<String, dynamic> episodeMap = result.data!['episode'];
    return EpisodeDetails.fromJson(episodeMap);
  }

  Future<({String? name, String? image})?> getMovieBasicInfo(int id) async {
    final QueryResult result = await client.query(
      QueryOptions(
        document: gql(queries.getMovieName),
        variables: <String, dynamic>{'id': id},
        fetchPolicy: FetchPolicy.cacheFirst,
      ),
    );
    if (result.hasException) return null;
    final data = result.data?['movie'];
    if (data == null) return null;
    return (name: data['name'] as String?, image: data['image'] as String?);
  }

  Future<Movie> getMovieDetails(int id) async {
    final QueryResult result = await client.query(
      QueryOptions(
        document: gql(queries.getMovieDetails),
        variables: <String, dynamic>{'id': id},
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );
    if (result.hasException) {
      throw Exception(result.exception.toString());
    }
    final movieMap =
        Map<String, dynamic>.from(result.data!['movie'] as Map<String, dynamic>);
    final translation = result.data!['movieTranslation'] as Map<String, dynamic>?;
    movieMap['overview'] = translation?['overview'] as String?;
    return Movie.fromJson(movieMap);
  }

  Future<SearchSeriesResult?> searchSeries(String name) async {
    final QueryResult result = await client.query(
      QueryOptions(
        document: gql(queries.searchSeries),
        variables: <String, dynamic>{'name': name},
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );
    if (result.hasException) {
      throw Exception(result.exception.toString());
    }
    if (result.data != null) {
      return SearchSeriesResult.fromJson(result.data!);
    }
    return null;
  }
}
