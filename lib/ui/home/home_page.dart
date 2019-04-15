import 'dart:async';

import 'package:episode_guide/blocs/blocs.dart';
import 'package:episode_guide/models/next_episode.dart';
import 'package:episode_guide/repositories/repositories.dart';
import 'package:episode_guide/ui/home/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

List<int> seriesIds = [
  266189,
  95011,
  269586,
  278518,
  328724,
  80379,
  121361,
  328487
];

class HomePage extends StatefulWidget {
  final TvdbRepository tvdbRepository;

  const HomePage({Key key, @required this.tvdbRepository}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  NextEpisodesBloc _nextEpisodesBloc;
  Completer<void> _refreshCompleter;

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
    _nextEpisodesBloc = NextEpisodesBloc(tvdbRepository: widget.tvdbRepository);
    _nextEpisodesBloc.dispatch(FetchNextEpisode(ids: seriesIds));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Column(
          children: <Widget>[
            Carousel(),
            Expanded(
              child: Container(
                child: BlocBuilder(
                  bloc: _nextEpisodesBloc,
                  builder: (_, NextEpisodeState state) {
                    if (state is NextEpisodeEmpty) {
                      return Center(
                        child: Text(
                          'No new episodes',
                          style: Theme.of(context).textTheme.subhead,
                        ),
                      );
                    }

                    if (state is NextEpisodeLoading) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (state is NextEpisodeLoaded) {
                      final List<NextEpisode> episodes = state.nextEpisodes
                          .where((ep) => ep.episodesSummary.nextEpisode != null)
                          .toList();

                      _refreshCompleter?.complete();
                      _refreshCompleter = Completer();

                      return RefreshIndicator(
                        onRefresh: () {
                          _nextEpisodesBloc
                              .dispatch(RefreshNextEpisode(ids: seriesIds));
                          return _refreshCompleter.future;
                        },
                        child: CustomScrollView(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          slivers: <Widget>[
                            SliverPadding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 24.0),
                              sliver: SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) =>
                                      EpisodeCard(episode: episodes[index]),
                                  childCount: episodes.length,
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    }

                    if (state is NextEpisodeError) {
                      return Text(
                        'Something went wrong! Please refresh',
                        style: TextStyle(color: Colors.red),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nextEpisodesBloc.dispose();
    super.dispose();
  }
}
