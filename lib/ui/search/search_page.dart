import 'package:episode_guide/blocs/blocs.dart';
import 'package:episode_guide/models/search_series_result.dart';
import 'package:episode_guide/ui/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchSeriesScreen extends StatefulWidget {
  static const routeName = '/searchSeries';

  const SearchSeriesScreen({super.key});

  @override
  _SearchSeriesScreenState createState() => _SearchSeriesScreenState();
}

class _SearchSeriesScreenState extends State<SearchSeriesScreen> {
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<SearchSeriesBloc>(context).add(ClearSearch());
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _search() {
    BlocProvider.of<SearchSeriesBloc>(context)
        .add(FetchSearchSeries(name: _textController.text));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: TextField(
          controller: _textController,
          autofocus: true,
          style: const TextStyle(color: Colors.white, fontSize: 19),
          textInputAction: TextInputAction.search,
          onSubmitted: (_) => _search(),
          decoration: const InputDecoration(
            hintText: 'Search for a series...',
            hintStyle: TextStyle(color: Colors.white38),
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _search,
          ),
        ],
      ),
      body: BlocBuilder<SearchSeriesBloc, SearchSeriesState>(
        builder: (_, SearchSeriesState state) {
          if (state is SearchSeriesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SearchSeriesEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.search_off, size: 56, color: Colors.white24),
                  const SizedBox(height: 12),
                  Text('No results found', style: theme.textTheme.titleMedium),
                ],
              ),
            );
          }

          if (state is SearchSeriesLoaded) {
            final List<SearchSeries> series =
                state.searchSeriesResult.searchSeries;
            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              itemCount: series.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: SearchResultCard(searchSeries: series[index]),
              ),
            );
          }

          if (state is SearchSeriesError) {
            return const Center(
              child: Text(
                'Something went wrong! Please try again',
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.tv, size: 64, color: Colors.white12),
                const SizedBox(height: 12),
                Text('Search for a series above',
                    style: theme.textTheme.titleMedium),
              ],
            ),
          );
        },
      ),
    );
  }
}
