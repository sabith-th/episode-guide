import 'package:episode_guide/models/next_episode.dart';
import 'package:episode_guide/models/search_series_result.dart';
import 'package:episode_guide/models/series_details.dart';
import 'package:episode_guide/models/series_episode.dart';
import 'package:episode_guide/repositories/tvdb_graphql_client.dart';

class TvdbRepository {
  final TvdbGraphQLClient tvdbGraphQLClient;

  TvdbRepository({required this.tvdbGraphQLClient});

  Future<List<NextEpisode>> getNextEpisodes(List<int> ids) async {
    final results = await Future.wait(
        ids.map((id) => tvdbGraphQLClient.getNextEpisode(id)));
    return results.whereType<NextEpisode>().toList();
  }

  Future<SeriesDetails> getSeriesDetails(int id) async {
    return await tvdbGraphQLClient.getSeriesDetails(id);
  }

  Future<List<SeriesEpisode>> getSeriesEpisodes(int id) async {
    return await tvdbGraphQLClient.getSeriesEpisodes(id);
  }

  Future<SearchSeriesResult?> searchSeries(String name) async {
    return await tvdbGraphQLClient.searchSeries(name);
  }
}
