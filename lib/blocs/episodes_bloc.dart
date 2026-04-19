import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:episode_guide/blocs/blocs.dart';
import 'package:episode_guide/models/next_episode.dart';
import 'package:episode_guide/repositories/repositories.dart';
import 'package:equatable/equatable.dart';

abstract class NextEpisodeEvent extends Equatable {
  const NextEpisodeEvent();

  @override
  List<Object> get props => [];
}

class FetchNextEpisode extends NextEpisodeEvent {
  final List<int> ids;

  const FetchNextEpisode({required this.ids});
}

class RefreshNextEpisode extends NextEpisodeEvent {
  final List<int> ids;

  const RefreshNextEpisode({required this.ids});
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

  const NextEpisodeLoaded({required this.nextEpisodes});
}

class NextEpisodesBloc extends Bloc<NextEpisodeEvent, NextEpisodeState> {
  final TvdbRepository tvdbRepository;
  final FavoritesBloc favoritesBloc;
  late final StreamSubscription<FavoritesState> _favoritesSubscription;

  NextEpisodesBloc(
      {required this.favoritesBloc, required this.tvdbRepository})
      : super(NextEpisodeEmpty()) {
    on<FetchNextEpisode>(_onFetchNextEpisode);
    on<RefreshNextEpisode>(_onRefreshNextEpisode);
    _favoritesSubscription = favoritesBloc.stream.listen((state) {
      if (state is FavoritesLoaded) {
        add(FetchNextEpisode(ids: state.seriesIds));
      }
    });
  }

  Future<void> _onFetchNextEpisode(
      FetchNextEpisode event, Emitter<NextEpisodeState> emit) async {
    emit(NextEpisodeLoading());
    try {
      final List<NextEpisode> nextEpisodes =
          await tvdbRepository.getNextEpisodes(event.ids);
      emit(NextEpisodeLoaded(nextEpisodes: nextEpisodes));
    } catch (error) {
      print('Something went wrong while fetching next episodes: $error');
      emit(NextEpisodeError());
    }
  }

  Future<void> _onRefreshNextEpisode(
      RefreshNextEpisode event, Emitter<NextEpisodeState> emit) async {
    try {
      final List<NextEpisode> nextEpisodes =
          await tvdbRepository.getNextEpisodes(event.ids);
      emit(NextEpisodeLoaded(nextEpisodes: nextEpisodes));
    } catch (error) {
      print('Something went wrong while fetching next episodes: $error');
    }
  }

  @override
  Future<void> close() {
    _favoritesSubscription.cancel();
    return super.close();
  }
}
