part of 'auth_bloc.dart';

sealed class AuthState {}

final class InitialAuthState extends AuthState {}

final class LoadingAuthState extends AuthState {}

final class AuthenticatedAuthState extends AuthState {
  final User user;

  AuthenticatedAuthState(this.user);
}

final class UnAuthenticatedAuthState extends AuthState {}

final class ErrorAuthState extends AuthState {
  final String message;

  ErrorAuthState(this.message);
}

final class SendingResetState extends AuthState {}

final class SendingResetSuccessState extends AuthState {}

final class SendingResetFailState extends AuthState {
  final String message;

  SendingResetFailState(this.message);
}

// final class RegisterLoadingState extends AuthState {}
//
// final class RegisterSuccessState extends AuthState {
//   final User user;
//
//   RegisterSuccessState(this.user);
// }
//
// final class RegisterFailState extends AuthState {
//   final String message;
//
//   RegisterFailState(this.message);
// }
