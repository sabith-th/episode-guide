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

class SeriesEpisodesBloc
    extends Bloc<SeriesEpisodesEvent, SeriesEpisodesState> {
  final TvdbRepository tvdbRepository;

  SeriesEpisodesBloc({required this.tvdbRepository})
      : super(SeriesEpisodesInitial()) {
    on<FetchSeriesEpisodes>(_onFetchSeriesEpisodes);
  }

  Future<void> _onFetchSeriesEpisodes(
      FetchSeriesEpisodes event, Emitter<SeriesEpisodesState> emit) async {
    emit(SeriesEpisodesLoading());
    try {
      final episodes =
          await tvdbRepository.getSeriesEpisodes(event.seriesId);
      emit(SeriesEpisodesLoaded(episodes: episodes));
    } catch (error) {
      print('Something went wrong while loading episodes: $error');
      emit(SeriesEpisodesError());
    }
  }
}
