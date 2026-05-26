import 'package:bloc/bloc.dart';
import 'package:episode_guide/models/series_episode.dart';
import 'package:episode_guide/repositories/repositories.dart';
import 'package:equatable/equatable.dart';

abstract class SeriesEpisodesEvent extends Equatable {
  const SeriesEpisodesEvent();
}

class FetchSeriesEpisodes extends SeriesEpisodesEvent {
  final int seriesId;

  const FetchSeriesEpisodes({required this.seriesId});

  @override
  List<Object> get props => [seriesId];
}

abstract class SeriesEpisodesState extends Equatable {
  const SeriesEpisodesState();

  @override
  List<Object> get props => [];
}

class SeriesEpisodesInitial extends SeriesEpisodesState {}

class SeriesEpisodesLoading extends SeriesEpisodesState {}

class SeriesEpisodesError extends SeriesEpisodesState {}

class SeriesEpisodesLoaded extends SeriesEpisodesState {
  final List<SeriesEpisode> episodes;

  const SeriesEpisodesLoaded({required this.episodes});

  @override
  List<Object> get props => [episodes];
}

class _CachedEpisodes {
  final List<SeriesEpisode> episodes;
  final DateTime fetchedAt;

  _CachedEpisodes(this.episodes) : fetchedAt = DateTime.now();

  bool get isExpired =>
      DateTime.now().difference(fetchedAt) > const Duration(minutes: 30);
}

class SeriesEpisodesBloc
    extends Bloc<SeriesEpisodesEvent, SeriesEpisodesState> {
  final TvdbRepository tvdbRepository;
  final Map<int, _CachedEpisodes> _cache = {};

  SeriesEpisodesBloc({required this.tvdbRepository})
      : super(SeriesEpisodesInitial()) {
    on<FetchSeriesEpisodes>(_onFetchSeriesEpisodes);
  }

  Future<void> _onFetchSeriesEpisodes(
      FetchSeriesEpisodes event, Emitter<SeriesEpisodesState> emit) async {
    final cached = _cache[event.seriesId];
    if (cached != null && !cached.isExpired) {
      emit(SeriesEpisodesLoaded(episodes: cached.episodes));
      return;
    }

    emit(SeriesEpisodesLoading());
    try {
      final episodes = await tvdbRepository.getSeriesEpisodes(event.seriesId);
      _cache[event.seriesId] = _CachedEpisodes(episodes);
      emit(SeriesEpisodesLoaded(episodes: episodes));
    } catch (error) {
      print('Something went wrong while loading episodes: $error');
      emit(SeriesEpisodesError());
    }
  }
}
