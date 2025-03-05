// screens/actor_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../models/actor.dart';
import '../providers/movie_providers.dart';

class ActorScreen extends ConsumerWidget {
  final int actorId;

  const ActorScreen({super.key, required this.actorId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actor = ref.watch(actorProvider(actorId));

    return Scaffold(
      body: actor.when(
        data: (data) => _ActorDetailView(actor: data),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }
}

class _ActorDetailView extends StatelessWidget {
  final Actor actor;

  const _ActorDetailView({required this.actor});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 300,
          flexibleSpace: FlexibleSpaceBar(
            background: CachedNetworkImage(
              imageUrl: 'https://image.tmdb.org/t/p/w1280${actor.profilePath}',
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: Colors.grey[800]),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Text(actor.name, style: Theme.of(context).textTheme.headlineMedium),
              if (actor.birthday != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text('Born: ${DateFormat.yMMMMd().format(actor.birthday!)}'),
                ),
              const SizedBox(height: 16),
              Text('Biography', style: Theme.of(context).textTheme.titleLarge),
              Text(actor.biography ?? 'No biography available'),
            ]),
          ),
        ),
      ],
    );
  }
}