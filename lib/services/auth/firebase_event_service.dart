import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/event.dart';

class FirebaseEventService {
  final String _apiKey = dotenv.get("WEB_API_KEY");
  final String _baseUrl = dotenv.get('BASE_URL');
  final _eventImageStorage = FirebaseStorage.instance;

  /// FETCH EVENTS
  Future<List<Event>> fetchEvents() async {
    final userToken = await _getUserToken();
    // debugPrint("USER TOKEN: $userToken");
    Uri url = Uri.parse("$_baseUrl/events.json?auth=$userToken");
    // debugPrint("URI: $url");
    try {
      final response = await http.get(url);

      if (response.statusCode != 200) {
        final errorData = jsonDecode(response.body);
        throw (errorData['error']);
      }

      final data = jsonDecode(response.body);
      // debugPrint("RESPONSE DATA: $data");
      List<Event> events = [];

      if (data != null) {
        data.forEach(
          (key, value) {
            events.add(
              Event(
                id: key,
                title: value['title'],
                description: value['description'],
                placeInfo: value['placeInfo'],
                date: DateTime.parse(value['date']),
                latitude: value['latitude'],
                longitude: value['longitude'],
                bannerImageUrl: value['bannerImageUrl'],
                isLiked: value['isLiked'],
              ),
            );
          },
        );
      }
      return events;
    } catch (e) {
      rethrow;
    }
  }

  /// ADD AN EVENT
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
    final imageRef = _eventImageStorage
        .ref()
        .child('eventImages')
        .child("${DateTime.now().microsecondsSinceEpoch}.jpg");
    final uploadTask = imageRef.putFile(imageFile);

    /// LISTENING TO UPLOAD PROGRESS
    uploadTask.snapshotEvents.listen(
      (status) {
        debugPrint("Uploading status: ${status.state}");
        double percentage =
            (status.bytesTransferred / imageFile.lengthSync()) * 100;
        debugPrint("Uploading percentage: $percentage");
      },
    );

    late String? imageUrl;

    await uploadTask.whenComplete(
      () async {
        imageUrl = await imageRef.getDownloadURL();
      },
    );

    if (imageUrl == null) {
      throw ("Couldn't get imageUrl.");
    }

    final userToken = await _getUserToken();
    Uri url = Uri.parse("$_baseUrl/events.json?auth=$userToken");

    try {
      final response = await http.post(
        url,
        body: jsonEncode({
          'title': title,
          'description': description,
          'placeInfo': placeInfo,
          'date': date.toString(),
          'latitude': latitude,
          'longitude': longitude,
          'bannerImageUrl': imageUrl,
          'isLiked': isLiked,
        }),
      );

      if (response.statusCode != 200) {
        final errorData = jsonDecode(response.body);
        throw (errorData['error']);
      }

      final data = jsonDecode(response.body);

      // debugPrint("ADDED EVENT: $data");

      final addedEvent = Event(
        id: data['name'],
        title: title,
        description: description,
        placeInfo: placeInfo,
        date: date,
        latitude: latitude,
        longitude: longitude,
        bannerImageUrl: imageUrl!,
        isLiked: isLiked,
      );

      return addedEvent;
    } catch (e) {
      rethrow;
    }
  }

  /// DELETE AN EVENT
  Future<void> deleteEvent({required String id}) async {
    final userToken = await _getUserToken();
    Uri url = Uri.parse("$_baseUrl/events/$id.json?auth=$userToken");
    try {
      final response = await http.delete(url);

      if (response.statusCode != 200) {
        final errorData = jsonDecode(response.body);
        throw (errorData['error']);
      }
    } catch (e) {
      rethrow;
    }
  }

  /// GET USER TOKEN
  Future<String> _getUserToken() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString("userData");

    if (userData == null) {
      // redirect to login
      debugPrint("NULL USERDATA: $userData");
    }

    Map<String, dynamic> user = jsonDecode(userData!);
    bool isTokenExpired = DateTime.now().isAfter(
      DateTime.parse(
        user['expiresIn'],
      ),
    );

    if (isTokenExpired) {
      // refresh token
      user = await _refreshToken(user);
      prefs.setString("userData", jsonEncode(user));
    }

    return user['idToken'];
  }

  /// GET NEW TOKEN with REFRESH TOKEN
  Future<Map<String, dynamic>> _refreshToken(Map<String, dynamic> user) async {
    Uri url =
        Uri.parse("https://securetoken.googleapis.com/v1/token?key=$_apiKey");

    try {
      final response = await http.post(
        url,
        body: jsonEncode(
          {
            "grant_type": "refresh_token",
            "refresh_token": user['refreshToken'],
          },
        ),
      );

      if (response.statusCode != 200) {
        final errorData = jsonDecode(response.body);
        throw (errorData['error']);
      }

      final data = jsonDecode(response.body);

      user['refreshToken'] = data['refresh_token'];
      user['idToken'] = data['id_token'];
      user['expiresIn'] = DateTime.now()
          .add(
            Duration(
              seconds: int.parse(
                data['expires_in'],
              ),
            ),
          )
          .toString();
      return user;
    } catch (e) {
      rethrow;
    }
  }
}
