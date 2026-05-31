import 'package:cached_network_image/cached_network_image.dart';
import 'package:episode_guide/blocs/blocs.dart';
import 'package:episode_guide/models/episode_details.dart';
import 'package:episode_guide/models/series_episode.dart';
import 'package:episode_guide/ui/series/person_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EpisodeDetailsScreen extends StatefulWidget {
  static const routeName = '/episodeDetails';

  const EpisodeDetailsScreen({super.key});

  @override
  State<EpisodeDetailsScreen> createState() => _EpisodeDetailsScreenState();
}

class _EpisodeDetailsScreenState extends State<EpisodeDetailsScreen> {
  bool _overviewExpanded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final episode =
        ModalRoute.of(context)!.settings.arguments as SeriesEpisode;
    BlocProvider.of<EpisodeDetailsBloc>(context)
        .add(FetchEpisodeDetails(episodeId: episode.id));
  }

  @override
  Widget build(BuildContext context) {
    final episode =
        ModalRoute.of(context)!.settings.arguments as SeriesEpisode;

    final seasonEpLabel = [
      if (episode.seasonNumber != null)
        'S${episode.seasonNumber!.toString().padLeft(2, '0')}',
      if (episode.number != null)
        'E${episode.number!.toString().padLeft(2, '0')}',
    ].join('');

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _HeroHeader(episode: episode)),
          // Basic info — available immediately from args
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: _InfoSection(
                episode: episode,
                seasonEpLabel: seasonEpLabel,
              ),
            ),
          ),
          if (episode.overview != null && episode.overview!.isNotEmpty)
            SliverToBoxAdapter(
              child: _OverviewSection(
                overview: episode.overview!,
                expanded: _overviewExpanded,
                onToggle: () =>
                    setState(() => _overviewExpanded = !_overviewExpanded),
              ),
            ),
          // Enriched data — silently loaded via BLoC, appears when available
          SliverToBoxAdapter(
            child: BlocBuilder<EpisodeDetailsBloc, EpisodeDetailsState>(
              builder: (_, state) {
                if (state is EpisodeDetailsLoaded) {
                  return _EnrichedSection(details: state.details);
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}

class _HeroHeader extends StatelessWidget {
  final SeriesEpisode episode;

  const _HeroHeader({required this.episode});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 240,
          width: double.infinity,
          child: episode.image != null
              ? CachedNetworkImage(
                  imageUrl: episode.image!,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  progressIndicatorBuilder: (_, __, ___) =>
                      Container(color: const Color(0xFF1C1C1C)),
                  errorWidget: (_, __, ___) => _placeholder(),
                )
              : _placeholder(),
        ),
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
        Positioned(
          bottom: 12, left: 16, right: 16,
          child: Text(
            episode.episodeName,
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
          child: Icon(Icons.movie, size: 80, color: Colors.white12),
        ),
      );
}

class _InfoSection extends StatelessWidget {
  final SeriesEpisode episode;
  final String seasonEpLabel;

  const _InfoSection({required this.episode, required this.seasonEpLabel});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 24,
      runSpacing: 8,
      children: [
        if (seasonEpLabel.isNotEmpty)
          _InfoChip(icon: Icons.format_list_numbered, label: seasonEpLabel),
        if (episode.airDate != null)
          _InfoChip(icon: Icons.calendar_today, label: episode.airDate!),
        if (episode.runtime != null)
          _InfoChip(
              icon: Icons.timer_outlined, label: '${episode.runtime} min'),
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

class _EnrichedSection extends StatelessWidget {
  final EpisodeDetails details;

  const _EnrichedSection({required this.details});

  String? _finaleLabel(String? type) {
    switch (type) {
      case 'season':
        return 'Season Finale';
      case 'series':
        return 'Series Finale';
      case 'midSeason':
        return 'Mid-Season Finale';
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final finaleLabel = _finaleLabel(details.finaleType);
    final networks = details.networks ?? [];
    final studios = details.studios ?? [];
    final cast = (details.characters ?? [])
        .where((c) => c.personName != null)
        .toList()
      ..sort((a, b) {
        final af = a.isFeatured ?? false;
        final bf = b.isFeatured ?? false;
        if (af != bf) return af ? -1 : 1;
        return (a.sort ?? 999).compareTo(b.sort ?? 999);
      });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Finale badge
        if (finaleLabel != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withAlpha(40),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: Theme.of(context).colorScheme.primary, width: 1),
              ),
              child: Text(
                finaleLabel,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        // Networks & Studios
        if (networks.isNotEmpty || studios.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Wrap(
              spacing: 24,
              runSpacing: 8,
              children: [
                ...networks.where((n) => n.name != null).map((n) =>
                    _InfoChip(icon: Icons.tv_outlined, label: n.name!)),
                ...studios.where((s) => s.name != null).map((s) =>
                    _InfoChip(icon: Icons.movie_creation_outlined, label: s.name!)),
              ],
            ),
          ),
        // Guest cast
        if (cast.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
            child: Text(
              'Guest Cast',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
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
                                ? CachedNetworkImageProvider(
                                    member.personImgURL!)
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
      ],
    );
  }
}
