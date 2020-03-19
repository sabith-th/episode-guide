import 'package:episode_guide/blocs/blocs.dart';
import 'package:episode_guide/models/search_series_result.dart';
import 'package:episode_guide/ui/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchSeriesScreen extends StatefulWidget {
  static const routeName = '/searchSeries';

  @override
  _SearchSeriesScreenState createState() => _SearchSeriesScreenState();
}

class _SearchSeriesScreenState extends State<SearchSeriesScreen> {
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Series'),
      ),
      backgroundColor: Colors.black,
      body: Container(
        color: Colors.white,
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
                      BlocProvider.of<SearchSeriesBloc>(context)
                          .add(FetchSearchSeries(name: _textController.text));
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.black,
                child: BlocBuilder<SearchSeriesBloc, SearchSeriesState>(
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
                                (context, index) => SearchResultCard(
                                    searchSeries: series[index]),
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

                    return Container();
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
