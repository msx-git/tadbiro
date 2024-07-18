import 'package:flutter/widgets.dart';
import 'package:tadbiro/utils/exports/ui.dart';

class AppRoute {
  AppRoute._();

  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String resetPassword = '/resetPassword';
  static const String home = '/home';
  static const String myEvents = '/myEvents';
  static const String addEvent = '/addEvent';
  static const String profile = '/profile';
  static const String languages = '/languages';
  static const String modes = '/modes';
  static const String notifications = '/notifications';

  static final routes = <String, WidgetBuilder>{
    splash: (BuildContext context) => const SplashScreen(),
    login: (BuildContext context) => const LoginScreen(),
    register: (BuildContext context) => const RegisterScreen(),
    resetPassword: (BuildContext context) => const ResetPasswordScreen(),
    home: (BuildContext context) => const HomeScreen(),
    myEvents: (BuildContext context) => const MyEventsScreen(),
    addEvent: (BuildContext context) => const AddEventScreen(),
    profile: (BuildContext context) => const ProfileInfoScreen(),
    languages: (BuildContext context) => const ChangeLanguageScreen(),
    modes: (BuildContext context) => const ChangeModeScreen(),
    notifications: (BuildContext context) => const NotificationsScreen(),
  };
}
