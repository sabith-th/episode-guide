import 'package:cached_network_image/cached_network_image.dart';
import 'package:episode_guide/blocs/blocs.dart';
import 'package:episode_guide/constants.dart';
import 'package:episode_guide/models/next_episode.dart';
import 'package:episode_guide/ui/series/series_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EpisodeCard extends StatelessWidget {
  const EpisodeCard({
    Key key,
    @required this.episode,
  }) : super(key: key);

  final NextEpisode episode;

  @override
  Widget build(BuildContext context) {
    SeriesDetailsBloc _seriesDetailsBloc = BlocProvider.of<SeriesDetailsBloc>(context);
    Episode nextEpisode = episode.episodesSummary.nextEpisode;

    return Card(
      child: InkWell(
        splashColor: Colors.black.withAlpha(30),
        onTap: () {
          _seriesDetailsBloc.dispatch(FetchSeriesDetails(id: episode.series.id));
          Navigator.pushNamed(
            context,
            SeriesDetailsScreen.routeName,
            arguments: SeriesDetailsArgs(
              episode.series.id,
              episode.series.seriesName,
              episode.images[0].fileName,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IntrinsicHeight(
            child: Row(
              children: <Widget>[
                Hero(
                  tag: 'seriesImage-${episode.series.id}',
                  child: SizedBox(
                    height: 110,
                    width: 75,
                    child: CachedNetworkImage(
                      imageUrl: TVDB_API_IMAGES + episode.images[0].fileName,
                      placeholder: (context, url) =>
                          new CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          new Icon(Icons.error),
                    ),
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
                          style: Theme.of(context)
                              .textTheme
                              .headline
                              .copyWith(color: Colors.black),
                        ),
                        Text(
                          'S${nextEpisode.airedSeason} E${nextEpisode.airedEpisodeNumber} - ${nextEpisode.episodeName}',
                          style: Theme.of(context)
                              .textTheme
                              .subhead
                              .copyWith(color: Colors.black),
                        ),
                        Text(
                          'Airs: ${nextEpisode.firstAired}',
                          style: Theme.of(context)
                              .textTheme
                              .subhead
                              .copyWith(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
