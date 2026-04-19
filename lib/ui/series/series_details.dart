import 'package:cached_network_image/cached_network_image.dart';
import 'package:episode_guide/blocs/blocs.dart';
import 'package:episode_guide/models/series.dart';
import 'package:episode_guide/models/series_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SeriesDetailsArgs {
  final int id;
  final String name;
  final String? image;

  SeriesDetailsArgs(this.id, this.name, this.image);
}

class SeriesDetailsScreen extends StatelessWidget {
  static const routeName = '/seriesDetails';

  const SeriesDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SeriesDetailsArgs args =
        ModalRoute.of(context)!.settings.arguments as SeriesDetailsArgs;
    final SeriesDetailsBloc seriesDetailsBloc =
        BlocProvider.of<SeriesDetailsBloc>(context);
    final FavoritesBloc favoritesBloc =
        BlocProvider.of<FavoritesBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(args.name),
      ),
      backgroundColor: Colors.black,
      floatingActionButton: BlocBuilder<FavoritesBloc, FavoritesState>(
        bloc: favoritesBloc,
        builder: (_, FavoritesState state) {
          bool isFavorite = false;
          if (state is FavoritesLoaded && state.seriesIds.contains(args.id)) {
            isFavorite = true;
          }
          return FloatingActionButton(
            onPressed: () {
              if (isFavorite) {
                favoritesBloc.add(RemoveFavorite(seriesId: args.id));
              } else {
                favoritesBloc.add(AddFavorite(seriesId: args.id));
              }
            },
            foregroundColor: Colors.green,
            child: Icon(
              isFavorite ? Icons.star : Icons.star_border,
              size: 36,
            ),
          );
        },
      ),
      body: BlocBuilder<SeriesDetailsBloc, SeriesDetailsState>(
          bloc: seriesDetailsBloc,
          builder: (_, SeriesDetailsState state) {
            if (state is SeriesDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is SeriesDetailsError) {
              return const Text(
                'Something went wrong!',
                style: TextStyle(color: Colors.red),
              );
            }

            if (state is SeriesDetailsLoaded) {
              final SeriesDetails seriesDetails = state.seriesDetails;
              final String? imageUrl =
                  args.image ?? seriesDetails.series.image;

              return ListView(
                children: <Widget>[
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Hero(
                          tag: 'seriesImage-${args.id}',
                          child: SizedBox(
                            height: 165,
                            width: 112.5,
                            child: imageUrl != null
                                ? CachedNetworkImage(
                                    imageUrl: imageUrl,
                                    progressIndicatorBuilder:
                                        (context, url, progress) =>
                                            const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  )
                                : const Icon(Icons.tv, size: 64),
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
                                  args.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                ),
                                if (seriesDetails.series.firstAired != null)
                                  Text(
                                    'First aired: ${seriesDetails.series.firstAired}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium,
                                  ),
                                if (seriesDetails.nextEpisode != null)
                                  Text(
                                    'Next: ${seriesDetails.nextEpisode!.firstAired ?? 'TBA'}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (seriesDetails.series.overview != null)
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        seriesDetails.series.overview!,
                        style: const TextStyle(color: Colors.white),
                        softWrap: true,
                      ),
                    ),
                  _buildCastSection(context, seriesDetails.series.characters),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
    );
  }

  Widget _buildCastSection(
      BuildContext context, List<Character>? characters) {
    if (characters == null || characters.isEmpty) return const SizedBox.shrink();

    final actors = characters
        .where((c) => c.peopleType == 'Actor')
        .toList()
      ..sort((a, b) {
        final aF = a.isFeatured ?? false;
        final bF = b.isFeatured ?? false;
        if (aF == bF) return 0;
        return aF ? -1 : 1;
      });

    if (actors.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 4.0),
          child: Text(
            'Cast',
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(color: Colors.white),
          ),
        ),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: actors.length,
            itemBuilder: (context, index) {
              final character = actors[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: Colors.grey[800],
                      backgroundImage: character.personImgURL != null
                          ? CachedNetworkImageProvider(
                              character.personImgURL!)
                          : null,
                      child: character.personImgURL == null
                          ? const Icon(Icons.person,
                              size: 36, color: Colors.white)
                          : null,
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      width: 72,
                      child: Text(
                        character.personName,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 11),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
