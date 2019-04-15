import 'package:episode_guide/models/next_episode.dart';
import 'package:episode_guide/models/series_details.dart';
import 'package:episode_guide/repositories/tvdb_graphql_client.dart';
import 'package:meta/meta.dart';

class TvdbRepository {
  final TvdbGraphQLClient tvdbGraphQLClient;

  TvdbRepository({@required this.tvdbGraphQLClient})
      : assert(tvdbGraphQLClient != null);

  Future<List<NextEpisode>> getNextEpisodes(List<int> ids) async {
    return await Future.wait(
        ids.map((id) => tvdbGraphQLClient.getNextEpisode(id)));
  }

  Future<SeriesDetails> getSeriesDetails(int id) async {
    return await tvdbGraphQLClient.getSeriesDetails(id);
  }
}
