part of 'otp_bloc.dart';

@immutable
sealed class OtpState {}

final class OtpInitial extends OtpState {}

final class OtpVarifySuccessfulState extends OtpState {}

final class OtpVarifyLoadingState extends OtpState {}

final class OtpVarifyErrorState extends OtpState {}

final class OtpVarifyInvalidPasswordState extends OtpState {}

final class OtpVarifyServerErrorState extends OtpState {}
