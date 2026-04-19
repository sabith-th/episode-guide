import 'package:cached_network_image/cached_network_image.dart';
import 'package:episode_guide/blocs/blocs.dart';
import 'package:episode_guide/models/series_episode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EpisodesScreenArgs {
  final int seriesId;
  final String seriesName;

  EpisodesScreenArgs(this.seriesId, this.seriesName);
}

class EpisodesScreen extends StatelessWidget {
  static const routeName = '/episodes';

  const EpisodesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as EpisodesScreenArgs;
    final bloc = BlocProvider.of<SeriesEpisodesBloc>(context);

    // Fetch on first open
    if (bloc.state is SeriesEpisodesInitial) {
      bloc.add(FetchSeriesEpisodes(seriesId: args.seriesId));
    }

    return Scaffold(
      appBar: AppBar(title: Text(args.seriesName)),
      body: BlocBuilder<SeriesEpisodesBloc, SeriesEpisodesState>(
        builder: (_, state) {
          if (state is SeriesEpisodesLoading || state is SeriesEpisodesInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SeriesEpisodesError) {
            return const Center(
              child: Text(
                'Could not load episodes',
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          if (state is SeriesEpisodesLoaded) {
            return _EpisodesList(episodes: state.episodes);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _EpisodesList extends StatefulWidget {
  final List<SeriesEpisode> episodes;

  const _EpisodesList({required this.episodes});

  @override
  State<_EpisodesList> createState() => _EpisodesListState();
}

class _EpisodesListState extends State<_EpisodesList> {
  final Set<int> _expandedSeasons = {};

  Map<int, List<SeriesEpisode>> _groupBySeasons(List<SeriesEpisode> episodes) {
    final map = <int, List<SeriesEpisode>>{};
    for (final ep in episodes) {
      final season = ep.seasonNumber ?? 0;
      (map[season] ??= []).add(ep);
    }
    // Sort episodes within each season
    for (final list in map.values) {
      list.sort((a, b) => (a.number ?? 0).compareTo(b.number ?? 0));
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final grouped = _groupBySeasons(widget.episodes);
    final seasons = grouped.keys.toList()..sort();

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      itemCount: seasons.length,
      itemBuilder: (context, index) {
        final season = seasons[index];
        final eps = grouped[season]!;
        final isExpanded = _expandedSeasons.contains(season);
        final label = season == 0 ? 'Specials' : 'Season $season';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Season header
            InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () => setState(() {
                if (isExpanded) {
                  _expandedSeasons.remove(season);
                } else {
                  _expandedSeasons.add(season);
                }
              }),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        label,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                    Text(
                      '${eps.length} ep${eps.length == 1 ? '' : 's'}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: Colors.white54,
                    ),
                  ],
                ),
              ),
            ),
            if (isExpanded)
              ...eps.map((ep) => _EpisodeTile(episode: ep)),
            const Divider(color: Colors.white12, height: 1),
          ],
        );
      },
    );
  }
}

class _EpisodeTile extends StatelessWidget {
  final SeriesEpisode episode;

  const _EpisodeTile({required this.episode});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final epLabel = episode.number != null ? 'E${episode.number}' : '';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Still image or placeholder
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 112,
              height: 64,
              child: episode.image != null
                  ? CachedNetworkImage(
                      imageUrl: episode.image!,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => _imagePlaceholder(),
                      progressIndicatorBuilder: (_, __, ___) =>
                          _imagePlaceholder(),
                    )
                  : _imagePlaceholder(),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (epLabel.isNotEmpty) ...[
                      Text(
                        epLabel,
                        style: theme.textTheme.bodyMedium!.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 6),
                    ],
                    Expanded(
                      child: Text(
                        episode.episodeName,
                        style: theme.textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                if (episode.airDate != null) ...[
                  const SizedBox(height: 2),
                  Text(episode.airDate!, style: theme.textTheme.bodyMedium),
                ],
                if (episode.overview != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    episode.overview!,
                    style: theme.textTheme.bodyMedium!
                        .copyWith(color: Colors.white38, fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _imagePlaceholder() => Container(
        color: const Color(0xFF2A2A2A),
        child: const Icon(Icons.movie, color: Colors.white12, size: 28),
      );
}
