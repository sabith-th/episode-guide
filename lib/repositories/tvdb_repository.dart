import 'package:episode_guide/models/episode_details.dart';
import 'package:episode_guide/models/movie.dart';
import 'package:episode_guide/models/next_episode.dart';
import 'package:episode_guide/models/person.dart';
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

  Future<Person> getPerson(int id) async {
    return await tvdbGraphQLClient.getPerson(id);
  }

  Future<({Map<int, String> names, Map<int, String> images})> getSeriesBasicInfo(
      List<int> ids) async {
    final results = await Future.wait(
      ids.map((id) async {
        final info = await tvdbGraphQLClient.getSeriesBasicInfo(id);
        return info != null ? (id: id, info: info) : null;
      }),
    );
    final names = <int, String>{};
    final images = <int, String>{};
    for (final entry in results.whereType<({int id, ({String? name, String? image}) info})>()) {
      if (entry.info.name != null) names[entry.id] = entry.info.name!;
      if (entry.info.image != null) images[entry.id] = entry.info.image!;
    }
    return (names: names, images: images);
  }

  Future<EpisodeDetails> getEpisodeDetails(int id) async {
    return await tvdbGraphQLClient.getEpisodeDetails(id);
  }

  Future<Movie> getMovieDetails(int id) async {
    return await tvdbGraphQLClient.getMovieDetails(id);
  }

  Future<({Map<int, String> names, Map<int, String> images})> getMovieBasicInfo(
      List<int> ids) async {
    final results = await Future.wait(
      ids.map((id) async {
        final info = await tvdbGraphQLClient.getMovieBasicInfo(id);
        return info != null ? (id: id, info: info) : null;
      }),
    );
    final names = <int, String>{};
    final images = <int, String>{};
    for (final entry
        in results.whereType<({int id, ({String? name, String? image}) info})>()) {
      if (entry.info.name != null) names[entry.id] = entry.info.name!;
      if (entry.info.image != null) images[entry.id] = entry.info.image!;
    }
    return (names: names, images: images);
  }

  Future<SearchSeriesResult?> searchSeries(String name) async {
    return await tvdbGraphQLClient.searchSeries(name);
  }
}
