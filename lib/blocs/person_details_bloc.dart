import 'package:bloc/bloc.dart';
import 'package:episode_guide/models/person.dart';
import 'package:episode_guide/repositories/repositories.dart';
import 'package:equatable/equatable.dart';

abstract class PersonDetailsEvent extends Equatable {
  const PersonDetailsEvent();
}

class FetchPersonDetails extends PersonDetailsEvent {
  final int personId;

  const FetchPersonDetails({required this.personId});

  @override
  List<Object> get props => [personId];
}

abstract class PersonDetailsState extends Equatable {
  const PersonDetailsState();

  @override
  List<Object> get props => [];
}

class PersonDetailsInitial extends PersonDetailsState {}

class PersonDetailsLoading extends PersonDetailsState {}

class PersonDetailsError extends PersonDetailsState {}

class PersonDetailsLoaded extends PersonDetailsState {
  final Person person;
  final Map<int, String> seriesNames;
  final Map<int, String> seriesImages;

  const PersonDetailsLoaded({
    required this.person,
    this.seriesNames = const {},
    this.seriesImages = const {},
  });

  @override
  List<Object> get props => [person, seriesNames, seriesImages];
}

class PersonDetailsBloc extends Bloc<PersonDetailsEvent, PersonDetailsState> {
  final TvdbRepository tvdbRepository;

  PersonDetailsBloc({required this.tvdbRepository})
      : super(PersonDetailsInitial()) {
    on<FetchPersonDetails>(_onFetchPersonDetails);
  }

  Future<void> _onFetchPersonDetails(
      FetchPersonDetails event, Emitter<PersonDetailsState> emit) async {
    emit(PersonDetailsLoading());
    try {
      final person = await tvdbRepository.getPerson(event.personId);
      emit(PersonDetailsLoaded(person: person));

      final seriesIds = person.characters
              ?.map((c) => c.seriesId)
              .whereType<int>()
              .toSet()
              .toList() ??
          [];

      if (seriesIds.isNotEmpty) {
        final info = await tvdbRepository.getSeriesBasicInfo(seriesIds);
        emit(PersonDetailsLoaded(
          person: person,
          seriesNames: info.names,
          seriesImages: info.images,
        ));
      }
    } catch (error) {
      print('Something went wrong while loading person details: $error');
      emit(PersonDetailsError());
    }
  }
}
