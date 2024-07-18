part of 'event_bloc.dart';

sealed class EventStates {}

final class InitialEventsState extends EventStates {}

final class LoadingEventsState extends EventStates {}

final class LoadedEventsState extends EventStates {
  final List<Event> events;

  LoadedEventsState({required this.events});
}

final class ErrorEventsState extends EventStates {
  final String errorMessage;

  ErrorEventsState({required this.errorMessage});
}
