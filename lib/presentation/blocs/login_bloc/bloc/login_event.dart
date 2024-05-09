// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

class UserLoginEvent extends LoginEvent {
  final String email;
  final String password;
  UserLoginEvent({
    required this.email,
    required this.password,
  });
}
