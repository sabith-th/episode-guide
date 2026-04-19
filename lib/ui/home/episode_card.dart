import 'package:cached_network_image/cached_network_image.dart';
import 'package:episode_guide/blocs/blocs.dart';
import 'package:episode_guide/models/next_episode.dart';
import 'package:episode_guide/ui/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EpisodeCard extends StatelessWidget {
  const EpisodeCard({
    super.key,
    required this.episode,
  });

  final NextEpisode episode;

  @override
  Widget build(BuildContext context) {
    final Episode? nextEpisode = episode.nextEpisode;
    final String? imageUrl = episode.series.image;
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          BlocProvider.of<SeriesDetailsBloc>(context)
              .add(FetchSeriesDetails(id: episode.series.id));
          Navigator.pushNamed(
            context,
            SeriesDetailsScreen.routeName,
            arguments: SeriesDetailsArgs(
              episode.series.id,
              episode.series.seriesName,
              imageUrl,
            ),
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Hero(
              tag: 'seriesImage-${episode.series.id}',
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                child: SizedBox(
                  height: 130,
                  width: 88,
                  child: imageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          progressIndicatorBuilder:
                              (context, url, progress) => Container(
                            color: const Color(0xFF2A2A2A),
                            child: const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: const Color(0xFF2A2A2A),
                            child: const Icon(Icons.tv,
                                size: 36, color: Colors.white30),
                          ),
                        )
                      : Container(
                          color: const Color(0xFF2A2A2A),
                          child: const Icon(Icons.tv,
                              size: 36, color: Colors.white30),
                        ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 12, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      episode.series.seriesName,
                      style: theme.textTheme.headlineMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    if (nextEpisode != null) ...[
                      Text(
                        nextEpisode.seasonNumber != null
                            ? 'S${nextEpisode.seasonNumber} · ${nextEpisode.episodeName ?? 'Episode'}'
                            : nextEpisode.episodeName ?? '',
                        style: theme.textTheme.titleMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today,
                              size: 13, color: Colors.white38),
                          const SizedBox(width: 4),
                          Text(
                            nextEpisode.firstAired ?? 'TBA',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ] else
                      Text(
                        'No upcoming episodes',
                        style: theme.textTheme.bodyMedium,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
