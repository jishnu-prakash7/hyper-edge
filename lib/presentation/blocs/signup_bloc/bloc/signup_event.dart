part of 'signup_bloc.dart';

@immutable
sealed class SignupEvent {}

class UserSignupEvent extends SignupEvent {
  final UserModel user;
  UserSignupEvent({
    required this.user,
  });
}
