import '../../services/auth/firebase_auth_service.dart';
import '../models/user.dart';

class AuthRepository {
  final FirebaseAuthService _firebaseAuthService;

  AuthRepository({
    required FirebaseAuthService firebaseAuthService,
  }) : _firebaseAuthService = firebaseAuthService;

  Future<User> login(String email, String password) async {
    return await _firebaseAuthService.login(email, password);
  }

  Future<User> register(String email, String password) async {
    return await _firebaseAuthService.register(email, password);
  }

  Future<User?> checkTokenExpiry() async {
    return await _firebaseAuthService.checkTokenExpiry();
  }

  Future<void> resetPassword(String email) async {
    await _firebaseAuthService.resetPassword(email);
  }

  Future<void> logOut() async {
    await _firebaseAuthService.logOut();
  }
}
