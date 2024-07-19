import 'dart:io';

import 'package:tadbiro/services/auth/firebase_event_service.dart';

import '../models/event.dart';

class EventRepository {
  final FirebaseEventService _firebaseEventService;

  EventRepository({required FirebaseEventService firebaseEventService})
      : _firebaseEventService = firebaseEventService;

  /// GET EVENTS REPOSITORY
  Future<List<Event>> getEvents() async {
    return await _firebaseEventService.fetchEvents();
  }

  /// ADD AN EVENT REPOSITORY
  Future<Event> addEvent({
    required String title,
    required String description,
    required String placeInfo,
    required DateTime date,
    required double latitude,
    required double longitude,
    required File imageFile,
    required bool isLiked,
  }) async {
    return await _firebaseEventService.addEvent(
      title: title,
      description: description,
      placeInfo: placeInfo,
      date: date,
      latitude: latitude,
      longitude: longitude,
      imageFile: imageFile,
      isLiked: isLiked,
    );
  }

  /// EDIT THE EVENT
  Future<void> editEvent({
    required String id,
    required String newTitle,
    required String newDescription,
    required String newPlaceInfo,
    required DateTime newDate,
    required double newLatitude,
    required double newLongitude,
    required String imageUrl,
    required File? newImageFile,
  }) async {
    await _firebaseEventService.editEvent(
      id: id,
      newTitle: newTitle,
      newDescription: newDescription,
      newPlaceInfo: newPlaceInfo,
      newDate: newDate,
      newLatitude: newLatitude,
      newLongitude: newLongitude,
      imageUrl: imageUrl,
      newImageFile: newImageFile,
    );
  }

  /// DELETE AN EVENT REPOSITORY
  Future<void> deleteEvent({required String id}) async {
    await _firebaseEventService.deleteEvent(id: id);
  }
}
