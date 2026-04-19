import 'package:episode_guide/blocs/blocs.dart';
import 'package:episode_guide/models/next_episode.dart';
import 'package:episode_guide/ui/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/';
  final void Function() onInit;

  const HomePage({super.key, required this.onInit});

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
        title: const Text('Episode Guide'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.pushNamed(context, SearchSeriesScreen.routeName);
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              BlocProvider.of<FavoritesBloc>(context).add(FetchFavorites());
            },
          ),
        ],
      ),
      body: BlocBuilder<NextEpisodesBloc, NextEpisodeState>(
        builder: (_, NextEpisodeState state) {
          if (state is NextEpisodeEmpty) {
            return _buildEmptyState(context, 'No favorites yet — search for a series to add one');
          }

          if (state is NextEpisodeLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is NextEpisodeLoaded) {
            final List<NextEpisode> episodes = state.nextEpisodes;

            if (episodes.isEmpty) {
              return _buildEmptyState(context, 'No upcoming episodes');
            }

            return CustomScrollView(
              slivers: <Widget>[
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      'Up Next',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(12, 4, 12, 24),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: EpisodeCard(episode: episodes[index]),
                      ),
                      childCount: episodes.length,
                    ),
                  ),
                ),
              ],
            );
          }

          if (state is NextEpisodeError) {
            return const Center(
              child: Text(
                'Something went wrong! Please refresh',
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          return _buildEmptyState(context, 'No new episodes');
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.tv_off, size: 64, color: Colors.white24),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
