import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tadbiro/data/repositories/event_repository.dart';

import '../../../data/models/event.dart';

part 'event_events.dart';
part 'event_states.dart';

class EventBloc extends Bloc<EventEvents, EventStates> {
  final EventRepository _eventRepository;

  EventBloc({required EventRepository eventRepository})
      : _eventRepository = eventRepository,
        super(InitialEventsState()) {
    on<GetEventsEvent>(_getEvents);
    on<AddEventEvent>(_addEvent);
    on<EditEventEvent>(_editEvent);
    on<DeleteEventEvent>(_deleteEvent);
    on<ToggleFavoriteEvent>(toggleFav);
  }

  void _getEvents(
    GetEventsEvent event,
    Emitter<EventStates> emit,
  ) async {
    emit(LoadingEventsState());

    try {
      // debugPrint("BEFORE LIST EVENTS:");
      final List<Event> events = await _eventRepository.getEvents();
      // debugPrint("LIST EVENTS: $events");
      emit(LoadedEventsState(events: events));
    } catch (e) {
      emit(ErrorEventsState(errorMessage: e.toString()));
    }
  }

  void _addEvent(
    AddEventEvent event,
    Emitter<EventStates> emit,
  ) async {
    List<Event> existingEvents = [];
    if (state is LoadedEventsState) {
      existingEvents = (state as LoadedEventsState).events;
    }
    emit(LoadingEventsState());

    try {
      final newEvent = await _eventRepository.addEvent(
        title: event.title,
        description: event.description,
        placeInfo: event.placeInfo,
        date: event.date,
        latitude: event.latitude,
        longitude: event.longitude,
        imageFile: event.imageFile,
        isLiked: event.isLiked,
      );
      existingEvents.add(newEvent);
      emit(LoadedEventsState(events: existingEvents));
    } catch (e) {
      emit(ErrorEventsState(errorMessage: e.toString()));
    }
  }

  void _editEvent(event, emit) async {
    List<Event> existingEvents = [];
    if (state is LoadedEventsState) {
      existingEvents = (state as LoadedEventsState).events;
    }
    emit(LoadingEventsState());
    try {
      await _eventRepository.editEvent(
        id: event.id,
        newTitle: event.newTitle,
        newDescription: event.newDescription,
        newPlaceInfo: event.newPlaceInfo,
        newDate: event.newDate,
        newLatitude: event.newLatitude,
        newLongitude: event.newLongitude,
        imageUrl: event.imageUrl,
        newImageFile: event.newImageFile,
      );

      for (var existingEvent in existingEvents) {
        if (existingEvent.id == event.id) {
          existingEvent.title = event.newTitle;
          existingEvent.description = event.newTitle;
          existingEvent.placeInfo = event.newTitle;
          existingEvent.date = event.newTitle;
          existingEvent.latitude = event.newTitle;
          existingEvent.longitude = event.newTitle;
          // existingEvent.bannerImageUrl = event.imageUrl;
        }
      }
    } catch (e) {
      emit(ErrorEventsState(errorMessage: e.toString()));
    }
  }

  void _deleteEvent(
    DeleteEventEvent event,
    Emitter emit,
  ) async {
    List<Event> existingEvents = [];
    if (state is LoadedEventsState) {
      existingEvents = (state as LoadedEventsState).events;
    }
    emit(LoadingEventsState());

    try {
      await _eventRepository.deleteEvent(id: event.id);
      existingEvents.removeWhere(
        (eachEvent) => eachEvent.id == event.id,
      );
      emit(LoadedEventsState(events: existingEvents));
    } catch (e) {
      emit(ErrorEventsState(errorMessage: e.toString()));
    }
  }

  void toggleFav(event, emit) {
    List<Event> existingEvents = [];
    if (state is LoadedEventsState) {
      existingEvents = (state as LoadedEventsState).events;
    }
    emit(LoadingEventsState());
    for (var existingEvent in existingEvents) {
      if (existingEvent.id == event.id) {
        existingEvent.isLiked = !existingEvent.isLiked;
      }
    }
    emit(LoadedEventsState(events: existingEvents));
  }
}
