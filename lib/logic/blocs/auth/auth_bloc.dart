import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

import '../../../data/models/user.dart';
import '../../../data/repositories/auth_repository.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(InitialAuthState()) {
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<LogoutEvent>(_onLogout);
    on<CheckTokenExpiryEvent>(_onCheckTokenExpiry);
    on<SendResetPasswordEvent>(_onSendResetPassword);
  }

  void _onLogin(LoginEvent event, Emitter emit) async {
    emit(LoadingAuthState());
    try {
      final user = await _authRepository.login(
        event.email,
        event.password,
      );
      emit(AuthenticatedAuthState(user));
    } catch (e) {
      debugPrint(e.toString());
      emit(ErrorAuthState(e.toString()));
    }
  }

  void _onRegister(RegisterEvent event, Emitter emit) async {
    emit(LoadingAuthState());
    try {
      final user = await _authRepository.register(
        event.email,
        event.password,
      );

      emit(AuthenticatedAuthState(user));
    } catch (e) {
      emit(ErrorAuthState(e.toString()));
    }
  }

  void _onLogout(LogoutEvent event, Emitter emit) async {
    emit(LoadingAuthState());
    try {
      await _authRepository.logOut();
      emit(UnAuthenticatedAuthState());
    } catch (e) {
      emit(ErrorAuthState(e.toString()));
    }
  }

  void _onSendResetPassword(SendResetPasswordEvent event, Emitter emit) async {
    try {
      emit(SendingResetState());
      await _authRepository.resetPassword(event.email);
      emit(SendingResetSuccessState());
    } catch (e) {
      emit(SendingResetFailState(e.toString()));
    }
  }

  void _onCheckTokenExpiry(CheckTokenExpiryEvent event, Emitter emit) async {
    emit(LoadingAuthState());
    final user = await _authRepository.checkTokenExpiry();
    if (user != null) {
      emit(AuthenticatedAuthState(user));
    } else {
      emit(UnAuthenticatedAuthState());
    }
  }
}
