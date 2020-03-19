import 'package:bloc/bloc.dart';
import 'package:episode_guide/repositories/repositories.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object> get props => [];
}

class FetchFavorites extends FavoritesEvent {}

class AddFavorite extends FavoritesEvent {
  final int seriesId;

  const AddFavorite({@required this.seriesId});

  @override
  List<Object> get props => [seriesId];
}

class RemoveFavorite extends FavoritesEvent {
  final int seriesId;

  const RemoveFavorite({@required this.seriesId});

  @override
  List<Object> get props => [seriesId];
}

abstract class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object> get props => [];
}

class FavoritesEmpty extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<int> seriesIds;

  const FavoritesLoaded({@required this.seriesIds});

  @override
  List<Object> get props => [seriesIds];
}

class FavoritesError extends FavoritesState {}

class FavoriteAdded extends FavoritesState {}

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  @override
  FavoritesState get initialState => FavoritesLoading();

  @override
  Stream<FavoritesState> mapEventToState(FavoritesEvent event) async* {
    final currentState = state;

    if (event is FetchFavorites) {
      yield FavoritesLoading();
      try {
        final List<int> seriesIds =
            await FavoritesRepository.getFavoriteSeriesList();
        if (seriesIds.isEmpty) {
          yield FavoritesEmpty();
        } else {
          yield FavoritesLoaded(seriesIds: seriesIds);
        }
      } catch (error) {
        print('Error loading favorites: $error');
        yield FavoritesError();
      }
    } else if (event is AddFavorite) {
      if (currentState is FavoritesLoaded) {
        final List<int> updatedSeriesIds = List.from(currentState.seriesIds)
          ..add(event.seriesId);
        yield FavoritesLoaded(seriesIds: updatedSeriesIds);
        FavoritesRepository.addFavoriteSeries(event.seriesId);
      } else if (currentState is FavoritesEmpty) {
        final List<int> updatedSeriesIds = [event.seriesId];
        yield FavoritesLoaded(seriesIds: updatedSeriesIds);
        FavoritesRepository.addFavoriteSeries(event.seriesId);
      }
    } else if (event is RemoveFavorite) {
      if (currentState is FavoritesLoaded) {
        final updatedSeriesIds =
            currentState.seriesIds.where((id) => id != event.seriesId).toList();
        yield FavoritesLoaded(seriesIds: updatedSeriesIds);
        FavoritesRepository.removeFavoriteSeries(event.seriesId);
      }
    }
  }
}
