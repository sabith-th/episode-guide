import 'package:bloc/bloc.dart';
import 'package:episode_guide/models/episode_details.dart';
import 'package:episode_guide/repositories/repositories.dart';
import 'package:equatable/equatable.dart';

abstract class EpisodeDetailsEvent extends Equatable {
  const EpisodeDetailsEvent();
}

class FetchEpisodeDetails extends EpisodeDetailsEvent {
  final int episodeId;

  const FetchEpisodeDetails({required this.episodeId});

  @override
  List<Object> get props => [episodeId];
}

abstract class EpisodeDetailsState extends Equatable {
  const EpisodeDetailsState();

  @override
  List<Object> get props => [];
}

class EpisodeDetailsInitial extends EpisodeDetailsState {}

class EpisodeDetailsLoading extends EpisodeDetailsState {}

class EpisodeDetailsError extends EpisodeDetailsState {}

class EpisodeDetailsLoaded extends EpisodeDetailsState {
  final EpisodeDetails details;

  const EpisodeDetailsLoaded({required this.details});

  @override
  List<Object> get props => [details];
}

class EpisodeDetailsBloc
    extends Bloc<EpisodeDetailsEvent, EpisodeDetailsState> {
  final TvdbRepository tvdbRepository;

  EpisodeDetailsBloc({required this.tvdbRepository})
      : super(EpisodeDetailsInitial()) {
    on<FetchEpisodeDetails>(_onFetchEpisodeDetails);
  }

  Future<void> _onFetchEpisodeDetails(
      FetchEpisodeDetails event, Emitter<EpisodeDetailsState> emit) async {
    emit(EpisodeDetailsLoading());
    try {
      final details = await tvdbRepository.getEpisodeDetails(event.episodeId);
      emit(EpisodeDetailsLoaded(details: details));
    } catch (error) {
      print('Something went wrong while loading episode details: $error');
      emit(EpisodeDetailsError());
    }
  }
}
