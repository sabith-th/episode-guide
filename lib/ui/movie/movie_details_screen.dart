import 'package:cached_network_image/cached_network_image.dart';
import 'package:episode_guide/blocs/blocs.dart';
import 'package:episode_guide/models/movie.dart';
import 'package:episode_guide/ui/series/person_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovieDetailsArgs {
  final int movieId;
  final String movieName;
  final String? movieImage;

  MovieDetailsArgs(this.movieId, this.movieName, this.movieImage);
}

class MovieDetailsScreen extends StatefulWidget {
  static const routeName = '/movieDetails';

  const MovieDetailsScreen({super.key});

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  bool _overviewExpanded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)!.settings.arguments as MovieDetailsArgs;
    BlocProvider.of<MovieDetailsBloc>(context)
        .add(FetchMovieDetails(movieId: args.movieId));
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as MovieDetailsArgs;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocBuilder<MovieDetailsBloc, MovieDetailsState>(
        builder: (_, state) {
          if (state is MovieDetailsLoading || state is MovieDetailsInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MovieDetailsError) {
            return const Center(
              child: Text(
                'Could not load movie details',
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          if (state is MovieDetailsLoaded) {
            final movie = state.movie;
            final imageUrl = movie.image ?? args.movieImage;
            final overview = movie.overview;

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: _HeroHeader(
                    imageUrl: imageUrl,
                    movieId: movie.id,
                    movieName: args.movieName,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: _InfoSection(movie: movie),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: _GenresRow(genres: movie.genres),
                  ),
                ),
                if (overview != null && overview.isNotEmpty)
                  SliverToBoxAdapter(
                    child: _OverviewSection(
                      overview: overview,
                      expanded: _overviewExpanded,
                      onToggle: () => setState(
                          () => _overviewExpanded = !_overviewExpanded),
                    ),
                  ),
                SliverToBoxAdapter(
                  child: _CastSection(characters: movie.characters),
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
  final int movieId;
  final String movieName;

  const _HeroHeader({
    required this.imageUrl,
    required this.movieId,
    required this.movieName,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 280,
          width: double.infinity,
          child: imageUrl != null
              ? CachedNetworkImage(
                  imageUrl: imageUrl!,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  progressIndicatorBuilder: (_, __, ___) =>
                      Container(color: const Color(0xFF1C1C1C)),
                  errorWidget: (_, __, ___) => _placeholder(),
                )
              : _placeholder(),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
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
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
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
        Positioned(
          bottom: 12,
          left: 16,
          right: 16,
          child: Text(
            movieName,
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
          child: Icon(Icons.movie_outlined, size: 80, color: Colors.white12),
        ),
      );
}

class _InfoSection extends StatelessWidget {
  final Movie movie;

  const _InfoSection({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 24,
      runSpacing: 8,
      children: [
        if (movie.year != null)
          _InfoChip(icon: Icons.calendar_today, label: movie.year!),
        if (movie.runtime != null)
          _InfoChip(
              icon: Icons.timer_outlined, label: '${movie.runtime} min'),
        if (movie.status != null)
          _InfoChip(icon: Icons.info_outline, label: movie.status!),
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

class _GenresRow extends StatelessWidget {
  final List<String>? genres;

  const _GenresRow({required this.genres});

  @override
  Widget build(BuildContext context) {
    if (genres == null || genres!.isEmpty) return const SizedBox.shrink();
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: genres!
          .map((g) => Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white24, width: 1),
                ),
                child: Text(
                  g,
                  style: const TextStyle(color: Colors.white60, fontSize: 13),
                ),
              ))
          .toList(),
    );
  }
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

class _CastSection extends StatelessWidget {
  final List<MovieCastMember>? characters;

  const _CastSection({required this.characters});

  @override
  Widget build(BuildContext context) {
    if (characters == null || characters!.isEmpty) {
      return const SizedBox.shrink();
    }

    final cast = characters!
        .where((c) => c.personName != null)
        .toList()
      ..sort((a, b) {
        final af = a.isFeatured ?? false;
        final bf = b.isFeatured ?? false;
        if (af != bf) return af ? -1 : 1;
        return (a.sort ?? 999).compareTo(b.sort ?? 999);
      });

    if (cast.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: Text('Cast', style: Theme.of(context).textTheme.headlineMedium),
        ),
        SizedBox(
          height: 172,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: cast.length,
            itemBuilder: (ctx, i) {
              final member = cast[i];
              return GestureDetector(
                onTap: member.peopleId != null
                    ? () => Navigator.pushNamed(
                          ctx,
                          PersonDetailsScreen.routeName,
                          arguments: PersonDetailsArgs(
                            member.peopleId!,
                            member.personName ?? '',
                            member.personImgURL,
                          ),
                        )
                    : null,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: SizedBox(
                    width: 100,
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 38,
                          backgroundColor: const Color(0xFF2A2A2A),
                          backgroundImage: member.personImgURL != null
                              ? CachedNetworkImageProvider(member.personImgURL!)
                              : null,
                          child: member.personImgURL == null
                              ? const Icon(Icons.person,
                                  size: 36, color: Colors.white24)
                              : null,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          member.personName!,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 13),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (member.name != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            member.name!,
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
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
