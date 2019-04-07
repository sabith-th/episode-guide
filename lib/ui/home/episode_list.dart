import 'package:episode_guide/graphql_operations/queries/queries.dart'
    as queries;
import 'package:episode_guide/models/next_episode.dart';
import 'package:episode_guide/ui/home/episode_card.dart';
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
            (context, index) => EpisodeCard(episode: episodes[index]),
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
