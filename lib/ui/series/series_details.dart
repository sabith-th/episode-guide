import 'package:cached_network_image/cached_network_image.dart';
import 'package:episode_guide/constants.dart';
import 'package:episode_guide/models/series_details.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:episode_guide/graphql_operations/queries/queries.dart'
    as queries;

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
      child: IntrinsicHeight(
        child: Row(
          children: <Widget>[
            SizedBox(
              height: 110,
              width: 75,
              child: CachedNetworkImage(
                imageUrl: TVDB_API_IMAGES + actor.image,
                placeholder: (context, url) => new CircularProgressIndicator(),
                errorWidget: (context, url, error) => new Icon(Icons.error),
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
                      actor.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      actor.role,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SeriesDetailsScreen extends StatelessWidget {
  static const routeName = '/seriesDetails';

  @override
  Widget build(BuildContext context) {
    final SeriesDetailsArgs args = ModalRoute.of(context).settings.arguments;
    return Query(
      options: QueryOptions(document: queries.getSeriesDetails, variables: {
        'id': args.id,
      }),
      builder: (QueryResult result) {
        if (result.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (result.hasErrors) {
          return Text('\nErrors: \n  ' + result.errors.join(',\n  '));
        }

        if (result.data == null && result.errors == null) {
          return const Text('Both data and errors are null');
        }

        Map<String, dynamic> seriesMap = result.data['seriesInfo'];
        SeriesDetails seriesDetails = SeriesDetails.fromJson(seriesMap);
        seriesDetails.actors.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

        return Scaffold(
          appBar: AppBar(
            title: Text(args.name),
          ),
          backgroundColor: Colors.black,
          body: Container(
            child: Column(
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
                            imageUrl: TVDB_API_IMAGES + args.image,
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
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Airs every ${seriesDetails.series.airsDayOfWeek} at ${seriesDetails.series.airsTime}',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                seriesDetails.series.network,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
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
                  style: TextStyle(
                    fontSize: 24.0,
                    color: Colors.white,
                  ),
                ),
                Divider(
                  color: Colors.white,
                ),
                Expanded(
                  child: CustomScrollView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    slivers: <Widget>[
                      SliverPadding(
                        padding: const EdgeInsets.all(8.0),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) =>
                                ActorCard(actor: seriesDetails.actors[index]),
                            childCount: seriesDetails.actors.length,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
