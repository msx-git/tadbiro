import 'dart:io';

import 'package:flutter/material.dart';
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
    required String bannerImageUrl,
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
      bannerImageUrl: bannerImageUrl,
      imageFile: imageFile,
      isLiked: isLiked,
    );
  }

  /// DELETE AN EVENT REPOSITORY
  Future<void> deleteEvent({required String id}) async {
    await _firebaseEventService.deleteEvent(id: id);
  }
}
