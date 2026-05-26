import 'package:cached_network_image/cached_network_image.dart';
import 'package:episode_guide/blocs/blocs.dart';
import 'package:episode_guide/models/person.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PersonDetailsArgs {
  final int personId;
  final String personName;
  final String? personImgURL;

  PersonDetailsArgs(this.personId, this.personName, this.personImgURL);
}

class PersonDetailsScreen extends StatefulWidget {
  static const routeName = '/personDetails';

  const PersonDetailsScreen({super.key});

  @override
  State<PersonDetailsScreen> createState() => _PersonDetailsScreenState();
}

class _PersonDetailsScreenState extends State<PersonDetailsScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)!.settings.arguments as PersonDetailsArgs;
    BlocProvider.of<PersonDetailsBloc>(context)
        .add(FetchPersonDetails(personId: args.personId));
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as PersonDetailsArgs;

    return Scaffold(
      appBar: AppBar(title: Text(args.personName)),
      body: BlocBuilder<PersonDetailsBloc, PersonDetailsState>(
        builder: (_, state) {
          if (state is PersonDetailsLoading || state is PersonDetailsInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is PersonDetailsError) {
            return const Center(
              child: Text(
                'Could not load person details',
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          if (state is PersonDetailsLoaded) {
            return _PersonBody(
              person: state.person,
              seriesNames: state.seriesNames,
              seriesImages: state.seriesImages,
              fallbackImage: args.personImgURL,
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _PersonBody extends StatelessWidget {
  final Person person;
  final Map<int, String> seriesNames;
  final Map<int, String> seriesImages;
  final String? fallbackImage;

  const _PersonBody({
    required this.person,
    required this.seriesNames,
    required this.seriesImages,
    required this.fallbackImage,
  });

  @override
  Widget build(BuildContext context) {
    final roles = person.characters ?? [];

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
      children: [
        _ProfileHeader(person: person, fallbackImage: fallbackImage),
        const SizedBox(height: 20),
        _BioSection(person: person),
        if (roles.isNotEmpty) ...[
          const SizedBox(height: 28),
          Text('Roles', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 12),
          _RolesGrid(roles: roles, seriesNames: seriesNames, seriesImages: seriesImages),
        ],
        if (person.awards != null && person.awards!.isNotEmpty) ...[
          const SizedBox(height: 28),
          Text('Awards', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 12),
          _AwardsList(awards: person.awards!),
        ],
      ],
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final Person person;
  final String? fallbackImage;

  const _ProfileHeader({required this.person, required this.fallbackImage});

  @override
  Widget build(BuildContext context) {
    final imageUrl = person.image ?? fallbackImage;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 56,
          backgroundColor: const Color(0xFF2A2A2A),
          backgroundImage:
              imageUrl != null ? CachedNetworkImageProvider(imageUrl) : null,
          child: imageUrl == null
              ? const Icon(Icons.person, size: 56, color: Colors.white24)
              : null,
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                person.name,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

}

class _BioSection extends StatelessWidget {
  final Person person;

  const _BioSection({required this.person});

  @override
  Widget build(BuildContext context) {
    final items = <({IconData icon, String label, String value})>[];
    if (person.birth != null)
      items.add((icon: Icons.cake_outlined, label: 'Born', value: person.birth!));
    if (person.birthPlace != null)
      items.add((
        icon: Icons.location_on_outlined,
        label: 'From',
        value: person.birthPlace!
      ));
    if (person.death != null)
      items.add((icon: Icons.hourglass_empty, label: 'Died', value: person.death!));

    if (items.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1C),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: items
            .map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(item.icon, size: 16, color: Colors.white38),
                      const SizedBox(width: 10),
                      Text('${item.label}:  ',
                          style: const TextStyle(
                              color: Colors.white38, fontSize: 15)),
                      Expanded(
                        child: Text(item.value,
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 15)),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }
}

class _RolesGrid extends StatelessWidget {
  final List<PersonRole> roles;
  final Map<int, String> seriesNames;
  final Map<int, String> seriesImages;

  const _RolesGrid({
    required this.roles,
    required this.seriesNames,
    required this.seriesImages,
  });

  @override
  Widget build(BuildContext context) {
    final sorted = [...roles]..sort((a, b) {
        final af = a.isFeatured ?? false;
        final bf = b.isFeatured ?? false;
        if (af != bf) return af ? -1 : 1;
        return (a.sort ?? 999).compareTo(b.sort ?? 999);
      });

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 14,
        childAspectRatio: 0.58,
      ),
      itemCount: sorted.length,
      itemBuilder: (_, i) => _RoleTile(
        role: sorted[i],
        seriesName: sorted[i].seriesId != null
            ? seriesNames[sorted[i].seriesId]
            : null,
        seriesImage: sorted[i].seriesId != null
            ? seriesImages[sorted[i].seriesId]
            : null,
      ),
    );
  }
}

class _RoleTile extends StatelessWidget {
  final PersonRole role;
  final String? seriesName;
  final String? seriesImage;

  const _RoleTile({required this.role, this.seriesName, this.seriesImage});

  @override
  Widget build(BuildContext context) {
    final typeLabel = role.seriesId != null
        ? (seriesName ?? 'TV Series')
        : role.movieId != null
            ? 'Movie'
            : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: AspectRatio(
            aspectRatio: 2 / 3,
            child: _buildImage(),
          ),
        ),
        const SizedBox(height: 5),
        if (role.name != null)
          Text(
            role.name!,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        if (typeLabel != null)
          Text(
            typeLabel,
            style: const TextStyle(color: Colors.white38, fontSize: 11),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
      ],
    );
  }

  Widget _buildImage() {
    final imageUrl = role.image ?? seriesImage;
    if (imageUrl != null) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        errorWidget: (_, __, ___) => _placeholder(),
        progressIndicatorBuilder: (_, __, ___) => _placeholder(),
      );
    }
    return _placeholder();
  }

  Widget _placeholder() => Container(
        color: const Color(0xFF2A2A2A),
        child: const Center(
            child: Icon(Icons.person, color: Colors.white12, size: 32)),
      );
}

class _AwardsList extends StatelessWidget {
  final List<PersonAward> awards;

  const _AwardsList({required this.awards});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: awards
          .map((a) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    const Icon(Icons.emoji_events_outlined,
                        size: 18, color: Colors.amber),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(a.name ?? 'Award',
                          style: Theme.of(context).textTheme.bodyMedium),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }
}
