import 'package:episode_guide/blocs/blocs.dart';
import 'package:episode_guide/models/search_series_result.dart';
import 'package:episode_guide/ui/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchResultCard extends StatelessWidget {
  final SearchSeries searchSeries;

  const SearchResultCard({Key key, this.searchSeries}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SeriesDetailsBloc _seriesDetailsBloc =
        BlocProvider.of<SeriesDetailsBloc>(context);

    return Card(
      child: InkWell(
        splashColor: Colors.black.withAlpha(30),
        onTap: () {
          _seriesDetailsBloc.dispatch(FetchSeriesDetails(id: searchSeries.id));
          Navigator.pushNamed(
            context,
            SeriesDetailsScreen.routeName,
            arguments: SeriesDetailsArgs(
              searchSeries.id,
              searchSeries.seriesName,
              null,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                searchSeries.seriesName,
                style: Theme.of(context)
                    .textTheme
                    .headline
                    .copyWith(color: Colors.black),
              ),
              Text(
                'Network: ${searchSeries.network}',
                style: Theme.of(context)
                    .textTheme
                    .subhead
                    .copyWith(color: Colors.black),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('First Aired: ${searchSeries.firstAired}'),
                  Text('Status: ${searchSeries.status}'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
