import 'package:episode_guide/blocs/blocs.dart';
import 'package:episode_guide/models/search_series_result.dart';
import 'package:episode_guide/ui/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchResultCard extends StatelessWidget {
  final SearchSeries searchSeries;

  const SearchResultCard({super.key, required this.searchSeries});

  @override
  Widget build(BuildContext context) {
    final SeriesDetailsBloc seriesDetailsBloc =
        BlocProvider.of<SeriesDetailsBloc>(context);
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          seriesDetailsBloc.add(FetchSeriesDetails(id: searchSeries.id));
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
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      searchSeries.seriesName,
                      style: theme.textTheme.headlineMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    if (searchSeries.network != null)
                      _MetaRow(
                        icon: Icons.broadcast_on_home,
                        label: searchSeries.network!,
                      ),
                    if (searchSeries.firstAired != null) ...[
                      const SizedBox(height: 3),
                      _MetaRow(
                        icon: Icons.calendar_today,
                        label: searchSeries.firstAired!,
                      ),
                    ],
                  ],
                ),
              ),
              if (searchSeries.status != null)
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _statusColor(searchSeries.status!).withAlpha(40),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _statusColor(searchSeries.status!).withAlpha(120),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    searchSeries.status!,
                    style: TextStyle(
                      fontSize: 11,
                      color: _statusColor(searchSeries.status!),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'continuing':
        return Colors.greenAccent;
      case 'ended':
        return Colors.redAccent;
      default:
        return Colors.white54;
    }
  }
}

class _MetaRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetaRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 13, color: Colors.white38),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
