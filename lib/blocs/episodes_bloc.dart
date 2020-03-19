import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:episode_guide/blocs/blocs.dart';
import 'package:episode_guide/models/next_episode.dart';
import 'package:episode_guide/repositories/repositories.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class NextEpisodeEvent extends Equatable {
  const NextEpisodeEvent();

  @override
  List<Object> get props => [];
}

class FetchNextEpisode extends NextEpisodeEvent {
  final List<int> ids;

  const FetchNextEpisode({@required this.ids});
}

class RefreshNextEpisode extends NextEpisodeEvent {
  final List<int> ids;

  const RefreshNextEpisode({@required this.ids});
}

abstract class NextEpisodeState extends Equatable {
  const NextEpisodeState();

  @override
  List<Object> get props => [];
}

class NextEpisodeEmpty extends NextEpisodeState {}

class NextEpisodeLoading extends NextEpisodeState {}

class NextEpisodeError extends NextEpisodeState {}

class NextEpisodeLoaded extends NextEpisodeState {
  final List<NextEpisode> nextEpisodes;

  const NextEpisodeLoaded({@required this.nextEpisodes});
}

class NextEpisodesBloc extends Bloc<NextEpisodeEvent, NextEpisodeState> {
  final TvdbRepository tvdbRepository;
  final FavoritesBloc favoritesBloc;
  StreamSubscription favoritesSubscription;

  NextEpisodesBloc({this.favoritesBloc, @required this.tvdbRepository}) {
    favoritesSubscription = favoritesBloc.listen((state) {
      if (state is FavoritesLoaded) {
        add(FetchNextEpisode(
            ids: (favoritesBloc.state as FavoritesLoaded).seriesIds));
      }
    });
  }

  @override
  NextEpisodeState get initialState => NextEpisodeEmpty();

  @override
  Stream<NextEpisodeState> mapEventToState(NextEpisodeEvent event) async* {
    final currentState = state;

    if (event is FetchNextEpisode) {
      yield NextEpisodeLoading();
      try {
        final List<NextEpisode> nextEpisodes =
            await tvdbRepository.getNextEpisodes(event.ids);
        yield NextEpisodeLoaded(nextEpisodes: nextEpisodes);
      } catch (error) {
        print('Something went wrong while fetching next episodes: $error');
        yield NextEpisodeError();
      }
    }

    if (event is RefreshNextEpisode) {
      try {
        final List<NextEpisode> nextEpisodes =
            await tvdbRepository.getNextEpisodes(event.ids);
        yield NextEpisodeLoaded(nextEpisodes: nextEpisodes);
      } catch (error) {
        print('Something went wrong while fetching next episodes: $error');
        yield currentState;
      }
    }
  }

  @override
  Future<Function> close() {
    favoritesSubscription.cancel();
    return super.close();
  }
}
