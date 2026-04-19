import 'package:episode_guide/graphql_operations/queries/queries.dart'
    as queries;
import 'package:episode_guide/models/next_episode.dart';
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
