import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/user.dart';

class FirebaseAuthService {
  final String _apiKey = dotenv.get("WEB_API_KEY");

  Future<User> _authenticate(
    String email,
    String password,
    String query,
  ) async {
    Uri url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:$query?key=$_apiKey");

    try {
      final response = await http.post(
        url,
        body: jsonEncode(
          {
            "email": email,
            "password": password,
            "returnSecureToken": true,
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final user = User.fromJson(data);
        _saveUserData(user);
        return user;
      }

      final errorData = jsonDecode(response.body);
      throw (errorData['error']['message']);
    } catch (e) {
      rethrow;
    }
  }

  Future<User> register(String email, String password) async {
    // signUp

    return await _authenticate(email, password, "signUp");
  }

  Future<User> login(String email, String password) async {
    // signUp

    return await _authenticate(email, password, "signInWithPassword");
  }

  Future<User?> checkTokenExpiry() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final userData = sharedPreferences.getString("userData");
    if (userData == null) {
      return null;
    }

    final user = jsonDecode(userData);

    if (DateTime.now().isBefore(
      DateTime.parse(
        user['expiresIn'],
      ),
    )) {
      return User(
        id: user['localId'],
        email: user['email'],
        firstName: '',
        lastName: '',
        imageUrl: '',
        profession: '',
        token: user['idToken'],
        expiresIn: DateTime.parse(
          user['expiresIn'],
        ),
      );
    }

    return null;
  }

  // reset password
  Future<void> resetPassword(String email) async {
    Uri url = Uri.parse(
      "https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=$_apiKey",
    );

    try {
      final response = await http.post(
        url,
        body: jsonEncode(
          {
            "requestType": "PASSWORD_RESET",
            "email": email,
          },
        ),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw (data['error']['message']);
      }
    } catch (e) {
      rethrow;
    }
  }

  // logout
  Future<void> logOut() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
  }

  Future<void> _saveUserData(User user) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(
      'userData',
      jsonEncode(
        user.toJson(),
      ),
    );
  }
}
