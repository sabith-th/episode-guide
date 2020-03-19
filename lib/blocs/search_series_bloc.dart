import 'package:bloc/bloc.dart';
import 'package:episode_guide/models/search_series_result.dart';
import 'package:episode_guide/repositories/repositories.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class SearchSeriesEvent extends Equatable {
  const SearchSeriesEvent();

  @override
  List<Object> get props => [];
}

class FetchSearchSeries extends SearchSeriesEvent {
  final String name;

  FetchSearchSeries({@required this.name});

  @override
  List<Object> get props => [name];
}

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

  const SearchSeriesLoaded({@required this.searchSeriesResult});

  @override
  List<Object> get props => [searchSeriesResult];
}

class SearchSeriesBloc extends Bloc<SearchSeriesEvent, SearchSeriesState> {
  final TvdbRepository tvdbRepository;

  SearchSeriesBloc({@required this.tvdbRepository});

  @override
  SearchSeriesState get initialState => SearchSeriesEmpty();

  @override
  Stream<SearchSeriesState> mapEventToState(SearchSeriesEvent event) async* {
    if (event is FetchSearchSeries) {
      yield SearchSeriesLoading();
      try {
        final SearchSeriesResult searchSeriesResult =
            await tvdbRepository.searchSeries(event.name);
        if (searchSeriesResult == null) {
          yield SearchSeriesEmpty();
        } else {
          yield SearchSeriesLoaded(searchSeriesResult: searchSeriesResult);
        }
      } catch (error) {
        print('Something went wrong while searching series : $error');
        yield SearchSeriesError();
      }
    }
  }
}
