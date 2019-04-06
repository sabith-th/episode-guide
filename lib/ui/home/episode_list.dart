import 'package:cached_network_image/cached_network_image.dart';
import 'package:episode_guide/constants.dart';
import 'package:episode_guide/graphql_operations/queries/queries.dart'
    as queries;
import 'package:episode_guide/models/next_episode.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

List<int> episodeIds = [
  266189,
  95011,
  269586,
  278518,
  328724,
  80379,
];

Widget _getEpisodeCard(NextEpisode episode) {
  Episode nextEpisode = episode.episodesSummary.nextEpisode;
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: IntrinsicHeight(
        child: Row(
          children: <Widget>[
            SizedBox(
              height: 110,
              width: 75,
              child: CachedNetworkImage(
                imageUrl: TVDB_API_IMAGES + episode.images[0].fileName,
                placeholder: (context, url) => new CircularProgressIndicator(),
                errorWidget: (context, url, error) => new Icon(Icons.error),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      episode.series.seriesName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    Text(
                      'S${nextEpisode.airedSeason} E${nextEpisode.airedEpisodeNumber} - ${nextEpisode.episodeName}',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      'Airs: ${nextEpisode.firstAired}',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Future _queryEpisode(GraphQLClient client, int id) {
  return client.query(
    QueryOptions(
      document: queries.getNextEpisode,
      variables: <String, dynamic>{
        'id': id,
        'keyType': 'POSTER',
      },
    ),
  );
}

Future<Widget> _getEpisodes(GraphQLClient client, List<int> episodeIds) async {
  List<QueryResult> results =
      await Future.wait(episodeIds.map((id) => _queryEpisode(client, id)));
  List<NextEpisode> episodes = [];
  for (int i = 0; i < results.length; i++) {
    Map<String, dynamic> episodeMap = results[i].data['seriesInfo'];
    NextEpisode nextEpisode = NextEpisode.fromJson(episodeMap);
    if (nextEpisode.episodesSummary.nextEpisode != null) {
      episodes.add(nextEpisode);
    }
  }

  return CustomScrollView(
    scrollDirection: Axis.vertical,
    shrinkWrap: true,
    slivers: <Widget>[
      SliverPadding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => _getEpisodeCard(episodes[index]),
            childCount: episodes.length,
          ),
        ),
      )
    ],
  );
}

class EpisodeList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GraphQLConsumer(
      builder: (GraphQLClient client) {
        return Expanded(
          child: Container(
            child: FutureBuilder(
              future: _getEpisodes(client, episodeIds),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data;
                } else if (snapshot.hasError) {
                  return new Text('${snapshot.error}');
                }
                return new Center(
                  child: new CircularProgressIndicator(),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
