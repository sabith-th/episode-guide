import 'package:bloc/bloc.dart';
import 'package:episode_guide/models/series_details.dart';
import 'package:episode_guide/repositories/repositories.dart';
import 'package:equatable/equatable.dart';

abstract class SeriesDetailsEvent extends Equatable {
  const SeriesDetailsEvent();
}

class FetchSeriesDetails extends SeriesDetailsEvent {
  final int id;

  const FetchSeriesDetails({required this.id});

  @override
  List<Object> get props => [id];
}

abstract class SeriesDetailsState extends Equatable {
  const SeriesDetailsState();

  @override
  List<Object> get props => [];
}

class SeriesDetailsEmpty extends SeriesDetailsState {}

class SeriesDetailsLoading extends SeriesDetailsState {}

class SeriesDetailsError extends SeriesDetailsState {}

class SeriesDetailsLoaded extends SeriesDetailsState {
  final SeriesDetails seriesDetails;

  const SeriesDetailsLoaded({required this.seriesDetails});

  @override
  List<Object> get props => [seriesDetails];
}

class SeriesDetailsBloc extends Bloc<SeriesDetailsEvent, SeriesDetailsState> {
  final TvdbRepository tvdbRepository;

  SeriesDetailsBloc({required this.tvdbRepository}) : super(SeriesDetailsEmpty()) {
    on<FetchSeriesDetails>(_onFetchSeriesDetails);
  }

  Future<void> _onFetchSeriesDetails(
      FetchSeriesDetails event, Emitter<SeriesDetailsState> emit) async {
    emit(SeriesDetailsLoading());
    try {
      final SeriesDetails seriesDetails =
          await tvdbRepository.getSeriesDetails(event.id);
      emit(SeriesDetailsLoaded(seriesDetails: seriesDetails));
    } catch (error) {
      print('Something went wrong while loading series details: $error');
      emit(SeriesDetailsError());
    }
  }
}
