part of 'login_bloc.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}

final class LoginSuccessfulState extends LoginState {
  // final LoginUserModel user;

  // LoginSuccessfulState({required this.user});
}

final class LoginErrorState extends LoginState {}

final class LoginUserNotFoundState extends LoginState {}

final class LoginAccountBlockedState extends LoginState {}

final class LoginInvalidPasswordState extends LoginState {}

final class LoginServerErrorState extends LoginState {}

final class LoginLoadingState extends LoginState {}
