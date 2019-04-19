import 'package:episode_guide/blocs/blocs.dart';
import 'package:episode_guide/models/search_series_result.dart';
import 'package:episode_guide/ui/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SeriesCard extends StatelessWidget {
  final SearchSeries searchSeries;

  const SeriesCard({Key key, this.searchSeries}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SeriesDetailsBloc _seriesDetailsBloc = BlocProvider.of<SeriesDetailsBloc>(context);

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
              '',
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

class SearchSeriesScreen extends StatefulWidget {
  static const routeName = '/searchSeries';

  @override
  _SearchSeriesScreenState createState() => _SearchSeriesScreenState();
}

class _SearchSeriesScreenState extends State<SearchSeriesScreen> {
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final SearchSeriesBloc _searchSeriesBloc =
        BlocProvider.of<SearchSeriesBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Search Series'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Form(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: TextFormField(
                        controller: _textController,
                        decoration: InputDecoration(
                          labelText: 'Series',
                          hintText: 'Type in the title of the series',
                        ),
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      _searchSeriesBloc.dispatch(
                          FetchSearchSeries(name: _textController.text));
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                child: BlocBuilder(
                  bloc: _searchSeriesBloc,
                  builder: (_, SearchSeriesState state) {
                    if (state is SearchSeriesLoading) {
                      return Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.black,
                        ),
                      );
                    }

                    if (state is SearchSeriesEmpty) {
                      return Center(
                        child: Text(
                          'No results found',
                          style: Theme.of(context)
                              .textTheme
                              .subhead
                              .copyWith(color: Colors.black),
                        ),
                      );
                    }

                    if (state is SearchSeriesLoaded) {
                      final List<SearchSeries> series =
                          state.searchSeriesResult.searchSeries;
                      return CustomScrollView(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        slivers: <Widget>[
                          SliverPadding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) =>
                                    SeriesCard(searchSeries: series[index]),
                                childCount: series.length,
                              ),
                            ),
                          )
                        ],
                      );
                    }

                    if (state is SearchSeriesError) {
                      return Center(
                        child: Text(
                          'Something went wrong! Please refresh',
                          style: TextStyle(color: Colors.red),
                        ),
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
}
