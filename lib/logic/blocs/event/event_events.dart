part of 'event_bloc.dart';

sealed class EventEvents {}

final class GetEventsEvent extends EventEvents {}

final class AddEventEvent extends EventEvents {
  String title;
  String description;
  String placeInfo;
  DateTime date;
  double latitude;
  double longitude;
  String bannerImageUrl;
  File imageFile;
  bool isLiked;

  AddEventEvent({
    required this.title,
    required this.description,
    required this.placeInfo,
    required this.date,
    required this.latitude,
    required this.longitude,
    required this.bannerImageUrl,
    required this.imageFile,
    required this.isLiked,
  });
}

final class DeleteEventEvent extends EventEvents {
  final String id;

  DeleteEventEvent({required this.id});
}
