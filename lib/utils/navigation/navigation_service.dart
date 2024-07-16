import 'package:flutter/material.dart';

class MyNavigator {
  late GlobalKey<NavigatorState> navigationKey;

  MyNavigator() {
    navigationKey = GlobalKey<NavigatorState>();
  }

  Future<dynamic> navigateToReplace(String routeName) {
    return navigationKey.currentState!.pushReplacementNamed(routeName);
  }

  Future<dynamic> navigateTo(String routeName, {dynamic arguments}) {
    return navigationKey.currentState!
        .pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> navigateToRoute(MaterialPageRoute routeName) {
    return navigationKey.currentState!.push(routeName);
  }

  void goBack() {
    navigationKey.currentState!.pop();
  }
}

final MyNavigator navigationService = MyNavigator();
