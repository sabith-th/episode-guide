import 'package:episode_guide/graphql_operations/queries/queries.dart'
    as queries;
import 'package:episode_guide/models/next_episode.dart';
import 'package:episode_guide/models/series_details.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:meta/meta.dart';

class TvdbGraphQLClient {
  final GraphQLClient client;

  TvdbGraphQLClient({@required this.client}) : assert(client != null);

  Future<NextEpisode> getNextEpisode(int id) async {
    QueryResult result = await client.query(
      QueryOptions(
        document: queries.getNextEpisode,
        variables: <String, dynamic>{
          'id': id,
          'keyType': 'POSTER',
        },
      ),
    );
    Map<String, dynamic> episodeMap = result.data['seriesInfo'];
    if (episodeMap != null) {
      return NextEpisode.fromJson(episodeMap);
    }
    return null;
  }

  Future<SeriesDetails> getSeriesDetails(int id) async {
    QueryResult result = await client.query(
      QueryOptions(
        document: queries.getSeriesDetails,
        variables: <String, dynamic>{
          'id': id,
        },
      ),
    );
    Map<String, dynamic> seriesMap = result.data['seriesInfo'];
    return SeriesDetails.fromJson(seriesMap);
  }
}
