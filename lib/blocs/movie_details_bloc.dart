import 'package:bloc/bloc.dart';
import 'package:episode_guide/models/movie.dart';
import 'package:episode_guide/repositories/repositories.dart';
import 'package:equatable/equatable.dart';

abstract class MovieDetailsEvent extends Equatable {
  const MovieDetailsEvent();
}

class FetchMovieDetails extends MovieDetailsEvent {
  final int movieId;

  const FetchMovieDetails({required this.movieId});

  @override
  List<Object> get props => [movieId];
}

abstract class MovieDetailsState extends Equatable {
  const MovieDetailsState();

  @override
  List<Object> get props => [];
}

class MovieDetailsInitial extends MovieDetailsState {}

class MovieDetailsLoading extends MovieDetailsState {}

class MovieDetailsError extends MovieDetailsState {}

class MovieDetailsLoaded extends MovieDetailsState {
  final Movie movie;

  const MovieDetailsLoaded({required this.movie});

  @override
  List<Object> get props => [movie];
}

class MovieDetailsBloc extends Bloc<MovieDetailsEvent, MovieDetailsState> {
  final TvdbRepository tvdbRepository;

  MovieDetailsBloc({required this.tvdbRepository})
      : super(MovieDetailsInitial()) {
    on<FetchMovieDetails>(_onFetchMovieDetails);
  }

  Future<void> _onFetchMovieDetails(
      FetchMovieDetails event, Emitter<MovieDetailsState> emit) async {
    emit(MovieDetailsLoading());
    try {
      final movie = await tvdbRepository.getMovieDetails(event.movieId);
      emit(MovieDetailsLoaded(movie: movie));
    } catch (error) {
      print('Something went wrong while loading movie details: $error');
      emit(MovieDetailsError());
    }
  }
}
