import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tadbiro/data/repositories/event_repository.dart';
import 'package:tadbiro/logic/blocs/event/event_bloc.dart';
import 'package:tadbiro/services/auth/firebase_event_service.dart';

import '../data/repositories/auth_repository.dart';
import '../logic/blocs/auth/auth_bloc.dart';
import '../services/auth/firebase_auth_service.dart';
import 'core/app.dart';
import 'firebase_options.dart';
import 'logic/blocs/observer/app_bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await dotenv.load(fileName: '.env');

  /// PERMISSIONS
  if (!(await Permission.camera.request().isGranted) ||
      !(await Permission.location.request().isGranted)) {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.camera,
    ].request();
    debugPrint("Permission statuses: $statuses");
  }
  final firebaseAuthService = FirebaseAuthService();
  final firebaseEventService = FirebaseEventService();
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => AuthRepository(
            firebaseAuthService: firebaseAuthService,
          ),
        ),
        RepositoryProvider(
          create: (context) =>
              EventRepository(firebaseEventService: firebaseEventService),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => EventBloc(
              eventRepository: context.read<EventRepository>(),
            ),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}
