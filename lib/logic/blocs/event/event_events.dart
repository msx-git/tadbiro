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
  File imageFile;
  bool isLiked;

  AddEventEvent({
    required this.title,
    required this.description,
    required this.placeInfo,
    required this.date,
    required this.latitude,
    required this.longitude,
    required this.imageFile,
    required this.isLiked,
  });
}

final class EditEventEvent extends EventEvents {
  String id;
  String newTitle;
  String newDescription;
  String newPlaceInfo;
  DateTime newDate;
  double newLatitude;
  double newLongitude;
  String imageUrl;
  File? newImageFile;

  EditEventEvent({
    required this.id,
    required this.newTitle,
    required this.newDescription,
    required this.newPlaceInfo,
    required this.newDate,
    required this.newLatitude,
    required this.newLongitude,
    required this.imageUrl,
    required this.newImageFile,
  });
}

final class DeleteEventEvent extends EventEvents {
  final String id;

  DeleteEventEvent({required this.id});
}

final class ToggleFavoriteEvent extends EventEvents {
  final String id;

  ToggleFavoriteEvent(this.id);
}
