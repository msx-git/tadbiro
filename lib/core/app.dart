import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../utils/exports/logics.dart';
import '../utils/exports/navigation.dart';
import '../utils/exports/ui.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // print("My APP -----------------------------------");
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocConsumer<AuthBloc, AuthState>(
        bloc: context.read<AuthBloc>()..add(CheckTokenExpiryEvent()),
        listener: (context, state) {
          // print("CONSUMER LISTENER ---------------------");
          if (state is LoadingAuthState) {
            Messages.showLoadingDialog(context);
          }
          if (state is ErrorAuthState ||
              state is AuthenticatedAuthState) {
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          print("CONSUMER BUILDER ---------------------");
          if (state is AuthenticatedAuthState) {
            return const HomeScreen();
          }
          return const LoginScreen();
        },
      ),
      routes: AppRoute.routes,
      navigatorKey: navigationService.navigationKey,
    );
  }
}
