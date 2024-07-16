import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../data/repositories/auth_repository.dart';
import '../logic/blocs/auth/auth_bloc.dart';
import '../services/auth/firebase_auth_service.dart';
import 'core/app.dart';

void main() async {
  // print("BEFORE WidgetsFlutterBinding.ensureInitialized();");
  WidgetsFlutterBinding.ensureInitialized();
  // print("AFTER WidgetsFlutterBinding.ensureInitialized();");
  await dotenv.load(fileName: '.env');
  // print("AFTER DOTENV");
  final firebaseAuthService = FirebaseAuthService();
  runApp(MultiRepositoryProvider(
    providers: [
      RepositoryProvider(
        create: (context) => AuthRepository(
          firebaseAuthService: firebaseAuthService,
        ),
      )
    ],
    child: MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(
            authRepository: context.read<AuthRepository>(),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  ));
}
