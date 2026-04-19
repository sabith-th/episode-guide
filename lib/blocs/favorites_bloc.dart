import 'package:bloc/bloc.dart';
import 'package:episode_guide/repositories/repositories.dart';
import 'package:equatable/equatable.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object> get props => [];
}

class FetchFavorites extends FavoritesEvent {}

class AddFavorite extends FavoritesEvent {
  final int seriesId;

  const AddFavorite({required this.seriesId});

  @override
  List<Object> get props => [seriesId];
}

class RemoveFavorite extends FavoritesEvent {
  final int seriesId;

  const RemoveFavorite({required this.seriesId});

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

  const FavoritesLoaded({required this.seriesIds});

  @override
  List<Object> get props => [seriesIds];
}

class FavoritesError extends FavoritesState {}

class FavoriteAdded extends FavoritesState {}

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc() : super(FavoritesLoading()) {
    on<FetchFavorites>(_onFetchFavorites);
    on<AddFavorite>(_onAddFavorite);
    on<RemoveFavorite>(_onRemoveFavorite);
  }

  Future<void> _onFetchFavorites(
      FetchFavorites event, Emitter<FavoritesState> emit) async {
    emit(FavoritesLoading());
    try {
      final List<int> seriesIds =
          await FavoritesRepository.getFavoriteSeriesList();
      if (seriesIds.isEmpty) {
        emit(FavoritesEmpty());
      } else {
        emit(FavoritesLoaded(seriesIds: seriesIds));
      }
    } catch (error) {
      print('Error loading favorites: $error');
      emit(FavoritesError());
    }
  }

  Future<void> _onAddFavorite(
      AddFavorite event, Emitter<FavoritesState> emit) async {
    final currentState = state;
    if (currentState is FavoritesLoaded) {
      final List<int> updatedSeriesIds = List.from(currentState.seriesIds)
        ..add(event.seriesId);
      emit(FavoritesLoaded(seriesIds: updatedSeriesIds));
      FavoritesRepository.addFavoriteSeries(event.seriesId);
    } else if (currentState is FavoritesEmpty) {
      emit(FavoritesLoaded(seriesIds: [event.seriesId]));
      FavoritesRepository.addFavoriteSeries(event.seriesId);
    }
  }

  Future<void> _onRemoveFavorite(
      RemoveFavorite event, Emitter<FavoritesState> emit) async {
    final currentState = state;
    if (currentState is FavoritesLoaded) {
      final updatedSeriesIds = currentState.seriesIds
          .where((id) => id != event.seriesId)
          .toList();
      emit(FavoritesLoaded(seriesIds: updatedSeriesIds));
      FavoritesRepository.removeFavoriteSeries(event.seriesId);
    }
  }
}
