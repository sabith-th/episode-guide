import 'package:cached_network_image/cached_network_image.dart';
import 'package:episode_guide/blocs/blocs.dart';
import 'package:episode_guide/constants.dart';
import 'package:episode_guide/models/series_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SeriesDetailsArgs {
  final int id;
  final String name;
  final String image;

  SeriesDetailsArgs(this.id, this.name, this.image);
}

class ActorCard extends StatelessWidget {
  final Actor actor;

  const ActorCard({Key key, this.actor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CircleAvatar(
            radius: 45.0,
            backgroundImage: CachedNetworkImageProvider(
              TVDB_API_IMAGES + actor.image,
            ),
          ),
          Text(
            actor.name,
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.white,
            ),
          ),
          Text(
            actor.role,
            style: TextStyle(
              fontSize: 10.0,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class SeriesDetailsScreen extends StatelessWidget {
  static const routeName = '/seriesDetails';

  @override
  Widget build(BuildContext context) {
    final SeriesDetailsArgs args = ModalRoute.of(context).settings.arguments;
    final SeriesDetailsBloc _seriesDetailsBloc =
        BlocProvider.of<SeriesDetailsBloc>(context);
    final FavoritesBloc _favoritesBloc =
        BlocProvider.of<FavoritesBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(args.name),
      ),
      backgroundColor: Colors.black,
      floatingActionButton: BlocBuilder(
        bloc: _favoritesBloc,
        builder: (_, FavoritesState state) {
          bool isFavorite = false;
          if (state is FavoritesLoaded && state.seriesIds.contains(args.id)) {
            isFavorite = true;
          }
          return FloatingActionButton(
            onPressed: () {
              if (isFavorite) {
                _favoritesBloc.add(RemoveFavorite(seriesId: args.id));
              } else {
                _favoritesBloc.add(AddFavorite(seriesId: args.id));
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
      body: Center(
        child: BlocBuilder(
          bloc: _seriesDetailsBloc,
          builder: (_, SeriesDetailsState state) {
            if (state is SeriesDetailsLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is SeriesDetailsError) {
              return Text(
                'Something went wrong!',
                style: TextStyle(color: Colors.red),
              );
            }
            if (state is SeriesDetailsLoaded) {
              SeriesDetails seriesDetails = state.seriesDetails;
              seriesDetails.actors
                  .sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

              return ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Column(
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
                                child: CachedNetworkImage(
                                  imageUrl: TVDB_API_IMAGES +
                                      (args.image != null
                                          ? args.image
                                          : seriesDetails.images[0].fileName),
                                  placeholder: (context, url) =>
                                      new CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      new Icon(Icons.error),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      args.name,
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                    ),
                                    Text(
                                      'Airs every ${seriesDetails.series.airsDayOfWeek} at ${seriesDetails.series.airsTime}',
                                      style:
                                          Theme.of(context).textTheme.subtitle1,
                                    ),
                                    Text(
                                      seriesDetails.series.network,
                                      style:
                                          Theme.of(context).textTheme.subtitle1,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          seriesDetails.series.overview,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          softWrap: true,
                        ),
                      ),
                      Text(
                        'Cast',
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      Divider(
                        color: Colors.white,
                      ),
                      Container(
                        height: 170,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: seriesDetails.actors.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              width: 100.0,
                              child:
                                  ActorCard(actor: seriesDetails.actors[index]),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
