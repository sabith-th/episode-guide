import 'package:bloc/bloc.dart';
import 'package:episode_guide/models/search_series_result.dart';
import 'package:episode_guide/repositories/repositories.dart';
import 'package:equatable/equatable.dart';

abstract class SearchSeriesEvent extends Equatable {
  const SearchSeriesEvent();

  @override
  List<Object> get props => [];
}

class FetchSearchSeries extends SearchSeriesEvent {
  final String name;

  const FetchSearchSeries({required this.name});

  @override
  List<Object> get props => [name];
}

class ClearSearch extends SearchSeriesEvent {}

abstract class SearchSeriesState extends Equatable {
  const SearchSeriesState();

  @override
  List<Object> get props => [];
}

class SearchSeriesEmpty extends SearchSeriesState {}

class SearchSeriesLoading extends SearchSeriesState {}

class SearchSeriesError extends SearchSeriesState {}

class SearchSeriesLoaded extends SearchSeriesState {
  final SearchSeriesResult searchSeriesResult;

  const SearchSeriesLoaded({required this.searchSeriesResult});

  @override
  List<Object> get props => [searchSeriesResult];
}

class SearchSeriesBloc extends Bloc<SearchSeriesEvent, SearchSeriesState> {
  final TvdbRepository tvdbRepository;

  SearchSeriesBloc({required this.tvdbRepository}) : super(SearchSeriesEmpty()) {
    on<FetchSearchSeries>(_onFetchSearchSeries);
    on<ClearSearch>((_, emit) => emit(SearchSeriesEmpty()));
  }

  Future<void> _onFetchSearchSeries(
      FetchSearchSeries event, Emitter<SearchSeriesState> emit) async {
    emit(SearchSeriesLoading());
    try {
      final SearchSeriesResult? searchSeriesResult =
          await tvdbRepository.searchSeries(event.name);
      if (searchSeriesResult == null) {
        emit(SearchSeriesEmpty());
      } else {
        emit(SearchSeriesLoaded(searchSeriesResult: searchSeriesResult));
      }
    } catch (error) {
      print('Something went wrong while searching series: $error');
      emit(SearchSeriesError());
    }
  }
}
