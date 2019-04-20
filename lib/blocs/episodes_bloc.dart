import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:episode_guide/blocs/blocs.dart';
import 'package:episode_guide/models/next_episode.dart';
import 'package:episode_guide/repositories/repositories.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class NextEpisodeEvent extends Equatable {
  NextEpisodeEvent([List props = const []]) : super(props);
}

class FetchNextEpisode extends NextEpisodeEvent {
  final List<int> ids;

  FetchNextEpisode({@required this.ids}) : super([ids]);
}

class RefreshNextEpisode extends NextEpisodeEvent {
  final List<int> ids;

  RefreshNextEpisode({@required this.ids}) : super([ids]);
}

abstract class NextEpisodeState extends Equatable {
  NextEpisodeState([List props = const []]) : super(props);
}

class NextEpisodeEmpty extends NextEpisodeState {}

class NextEpisodeLoading extends NextEpisodeState {}

class NextEpisodeError extends NextEpisodeState {}

class NextEpisodeLoaded extends NextEpisodeState {
  final List<NextEpisode> nextEpisodes;

  NextEpisodeLoaded({@required this.nextEpisodes}) : super([nextEpisodes]);
}

class NextEpisodesBloc extends Bloc<NextEpisodeEvent, NextEpisodeState> {
  final TvdbRepository tvdbRepository;
  final FavoritesBloc favoritesBloc;
  StreamSubscription favoritesSubscription;

  NextEpisodesBloc({this.favoritesBloc, @required this.tvdbRepository}) {
    favoritesSubscription = favoritesBloc.state.listen((state) {
      if (state is FavoritesLoaded) {
        dispatch(FetchNextEpisode(
            ids: (favoritesBloc.currentState as FavoritesLoaded).seriesIds));
      }
    });
  }

  @override
  NextEpisodeState get initialState => NextEpisodeEmpty();

  @override
  Stream<NextEpisodeState> mapEventToState(NextEpisodeEvent event) async* {
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
  void dispose() {
    favoritesSubscription.cancel();
    super.dispose();
  }


}
