import 'package:episode_guide/blocs/blocs.dart';
import 'package:episode_guide/models/next_episode.dart';
import 'package:episode_guide/ui/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/';
  final void Function() onInit;

  const HomePage({Key key, @required this.onInit}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    widget.onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Episode Guide',
          style: Theme.of(context).textTheme.headline5,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.pushNamed(context, SearchSeriesScreen.routeName);
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              BlocProvider.of<FavoritesBloc>(context).add(FetchFavorites());
            },
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                child: BlocBuilder<NextEpisodesBloc, NextEpisodeState>(
                  builder: (_, NextEpisodeState state) {
                    if (state is NextEpisodeEmpty) {
                      return Center(
                        child: Text(
                          'No new episodes',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      );
                    }

                    if (state is NextEpisodeLoading) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (state is NextEpisodeLoaded) {
                      final List<NextEpisode> episodes = state.nextEpisodes
                          .where(
                              (ep) => ep?.episodesSummary?.nextEpisode != null)
                          .toList();

                      return CustomScrollView(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        slivers: <Widget>[
                          SliverPadding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) =>
                                    EpisodeCard(episode: episodes[index]),
                                childCount: episodes.length,
                              ),
                            ),
                          )
                        ],
                      );
                    }

                    if (state is NextEpisodeError) {
                      return Center(
                        child: Text(
                          'Something went wrong! Please refresh',
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                    }

                    return Center(
                      child: Text(
                        'No new episodes',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
