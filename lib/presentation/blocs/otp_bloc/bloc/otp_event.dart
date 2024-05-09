part of 'otp_bloc.dart';

@immutable
sealed class OtpEvent {}

class OtpVerifyEvent extends OtpEvent {
  final String email;
  final String otp;
  OtpVerifyEvent({
    required this.email,
    required this.otp,
  });
}
