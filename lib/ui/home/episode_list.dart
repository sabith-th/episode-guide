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

class EpisodesCardList extends StatelessWidget {
  final List<NextEpisode> episodes;

  const EpisodesCardList({Key key, @required this.episodes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (episodes.length == 0) {
      return Card(
        child: Text(
          'No new episodes...'
        ),
      );
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
}

Future<List<NextEpisode>> _getEpisodes(
    GraphQLClient client, List<int> episodeIds) async {
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

  return episodes;
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
                if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                  return EpisodesCardList(episodes: snapshot.data);
                } else if (snapshot.hasError) {
                  return new Text(
                    '${snapshot.error}',
                    style: TextStyle(color: Colors.white),
                  );
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
