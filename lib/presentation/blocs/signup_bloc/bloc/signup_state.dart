part of 'signup_bloc.dart';

@immutable
sealed class SignupState {}

final class SignupInitialState extends SignupState {}

final class SignupLoadingState extends SignupState {}

final class SignupErrorState extends SignupState {}

final class SignupAlreadyAccountState extends SignupState {}

final class SignupServerErrorState extends SignupState {}

final class SignupOtpAlreadySendState extends SignupState {}

final class SignupSuccessfulState extends SignupState {}