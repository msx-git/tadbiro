import 'package:flutter/widgets.dart';
import 'package:tadbiro/ui/screen/auth/reset_password_screen.dart';

import '../../ui/screen/auth/login_screen.dart';
import '../../ui/screen/auth/register_screen.dart';
import '../../ui/screen/home/home_screen.dart';
import '../../ui/screen/splash/splash_screen.dart';

class AppRoute {
  AppRoute._();

  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String resetPassword = '/resetPassword';
  static const String home = '/home';

  static final routes = <String, WidgetBuilder>{
    splash: (BuildContext context) => const SplashScreen(),
    login: (BuildContext context) => const LoginScreen(),
    register: (BuildContext context) => const RegisterScreen(),
    resetPassword: (BuildContext context) => ResetPasswordScreen(),
    home: (BuildContext context) => const HomeScreen(),
  };
}
