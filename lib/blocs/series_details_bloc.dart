import 'package:bloc/bloc.dart';
import 'package:episode_guide/models/series_details.dart';
import 'package:episode_guide/repositories/repositories.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class SeriesDetailsEvent extends Equatable {
  SeriesDetailsEvent([List props = const []]) : super(props);
}

class FetchSeriesDetails extends SeriesDetailsEvent {
  final int id;

  FetchSeriesDetails({@required this.id}) : super([id]);
}

abstract class SeriesDetailsState extends Equatable {
  SeriesDetailsState([List props = const []]) : super(props);
}

class SeriesDetailsEmpty extends SeriesDetailsState {}

class SeriesDetailsLoading extends SeriesDetailsState {}

class SeriesDetailsError extends SeriesDetailsState {}

class SeriesDetailsLoaded extends SeriesDetailsState {
  final SeriesDetails seriesDetails;

  SeriesDetailsLoaded({@required this.seriesDetails}) : super([seriesDetails]);
}

class SeriesDetailsBloc extends Bloc<SeriesDetailsEvent, SeriesDetailsState> {
  final TvdbRepository tvdbRepository;

  SeriesDetailsBloc({@required this.tvdbRepository});

  @override
  SeriesDetailsState get initialState => SeriesDetailsEmpty();

  @override
  Stream<SeriesDetailsState> mapEventToState(SeriesDetailsEvent event) async* {
    if (event is FetchSeriesDetails) {
      yield SeriesDetailsLoading();
      try {
        final SeriesDetails seriesDetails =
            await tvdbRepository.getSeriesDetails(event.id);
        yield SeriesDetailsLoaded(seriesDetails: seriesDetails);
      } catch (error) {
        print('Something went wrong while series details: $error');
        yield SeriesDetailsError();
      }
    }
  }
}
