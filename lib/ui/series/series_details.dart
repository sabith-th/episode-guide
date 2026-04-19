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

class SeriesDetailsScreen extends StatefulWidget {
  static const routeName = '/seriesDetails';

  const SeriesDetailsScreen({super.key});

  @override
  State<SeriesDetailsScreen> createState() => _SeriesDetailsScreenState();
}

class _SeriesDetailsScreenState extends State<SeriesDetailsScreen> {
  bool _overviewExpanded = false;

  @override
  Widget build(BuildContext context) {
    final SeriesDetailsArgs args =
        ModalRoute.of(context)!.settings.arguments as SeriesDetailsArgs;
    final SeriesDetailsBloc seriesDetailsBloc =
        BlocProvider.of<SeriesDetailsBloc>(context);
    final FavoritesBloc favoritesBloc =
        BlocProvider.of<FavoritesBloc>(context);


    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          BlocBuilder<FavoritesBloc, FavoritesState>(
            bloc: favoritesBloc,
            builder: (_, FavoritesState state) {
              final isFavorite = state is FavoritesLoaded &&
                  state.seriesIds.contains(args.id);
              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.star : Icons.star_border,
                  color: isFavorite ? Colors.amber : Colors.white,
                  size: 28,
                ),
                onPressed: () {
                  if (isFavorite) {
                    favoritesBloc.add(RemoveFavorite(seriesId: args.id));
                  } else {
                    favoritesBloc.add(AddFavorite(seriesId: args.id));
                  }
                },
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<SeriesDetailsBloc, SeriesDetailsState>(
        bloc: seriesDetailsBloc,
        builder: (_, SeriesDetailsState state) {
          if (state is SeriesDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SeriesDetailsError) {
            return const Center(
              child: Text(
                'Something went wrong!',
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          if (state is SeriesDetailsLoaded) {
            final SeriesDetails seriesDetails = state.seriesDetails;
            final String? imageUrl =
                args.image ?? seriesDetails.series.image;

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: _HeroHeader(
                    imageUrl: imageUrl,
                    seriesId: args.id,
                    seriesName: args.name,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: _InfoSection(seriesDetails: seriesDetails),
                  ),
                ),
                if (seriesDetails.series.overview != null)
                  SliverToBoxAdapter(
                    child: _OverviewSection(
                      overview: seriesDetails.series.overview!,
                      expanded: _overviewExpanded,
                      onToggle: () => setState(
                          () => _overviewExpanded = !_overviewExpanded),
                    ),
                  ),
                SliverToBoxAdapter(
                  child: _CastSection(
                    characters: seriesDetails.series.characters,
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 32)),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _HeroHeader extends StatelessWidget {
  final String? imageUrl;
  final int seriesId;
  final String seriesName;

  const _HeroHeader({
    required this.imageUrl,
    required this.seriesId,
    required this.seriesName,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Hero(
          tag: 'seriesImage-$seriesId',
          child: SizedBox(
            height: 280,
            width: double.infinity,
            child: imageUrl != null
                ? CachedNetworkImage(
                    imageUrl: imageUrl!,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                    progressIndicatorBuilder: (context, url, progress) =>
                        Container(color: const Color(0xFF1C1C1C)),
                    errorWidget: (context, url, error) => _placeholder(),
                  )
                : _placeholder(),
          ),
        ),
        // top fade for AppBar overlap
        Positioned(
          top: 0, left: 0, right: 0,
          child: Container(
            height: 80,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xCC0D0D0D), Colors.transparent],
              ),
            ),
          ),
        ),
        // bottom fade into background
        Positioned(
          bottom: 0, left: 0, right: 0,
          child: Container(
            height: 100,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Color(0xFF0D0D0D), Colors.transparent],
              ),
            ),
          ),
        ),
        // series name at bottom of header
        Positioned(
          bottom: 12, left: 16, right: 16,
          child: Text(
            seriesName,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [Shadow(blurRadius: 8, color: Colors.black)],
            ),
          ),
        ),
      ],
    );
  }

  Widget _placeholder() => Container(
        color: const Color(0xFF1C1C1C),
        child: const Center(
          child: Icon(Icons.tv, size: 80, color: Colors.white12),
        ),
      );
}

class _OverviewSection extends StatelessWidget {
  final String overview;
  final bool expanded;
  final VoidCallback onToggle;

  const _OverviewSection({
    required this.overview,
    required this.expanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            crossFadeState: expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: Text(
              overview,
              style: const TextStyle(color: Colors.white70, height: 1.5),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            secondChild: Text(
              overview,
              style: const TextStyle(color: Colors.white70, height: 1.5),
            ),
          ),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: onToggle,
            child: Text(
              expanded ? 'Show less' : 'Read more',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final SeriesDetails seriesDetails;

  const _InfoSection({required this.seriesDetails});

  @override
  Widget build(BuildContext context) {
    final series = seriesDetails.series;
    return Wrap(
      spacing: 24,
      runSpacing: 8,
      children: [
        if (series.firstAired != null)
          _InfoChip(icon: Icons.calendar_today, label: 'First aired: ${series.firstAired!}'),
        if (seriesDetails.nextEpisode != null)
          _InfoChip(
            icon: Icons.upcoming,
            label: 'Next: ${seriesDetails.nextEpisode!.firstAired ?? 'TBA'}',
          ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.white38),
        const SizedBox(width: 5),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}

class _CastSection extends StatelessWidget {
  final List<Character>? characters;

  const _CastSection({required this.characters});

  @override
  Widget build(BuildContext context) {
    if (characters == null || characters!.isEmpty) {
      return const SizedBox.shrink();
    }

    final actors = characters!
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
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: Text(
            'Cast',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        SizedBox(
          height: 172,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: actors.length,
            itemBuilder: (context, index) {
              final character = actors[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: SizedBox(
                  width: 100,
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 38,
                        backgroundColor: const Color(0xFF2A2A2A),
                        backgroundImage: character.personImgURL != null
                            ? CachedNetworkImageProvider(
                                character.personImgURL!)
                            : null,
                        child: character.personImgURL == null
                            ? const Icon(Icons.person,
                                size: 36, color: Colors.white24)
                            : null,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        character.personName,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 13),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (character.name != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          character.name!,
                          style: const TextStyle(
                              color: Colors.white38, fontSize: 12),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
