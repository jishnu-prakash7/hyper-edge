import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:social_media/data/repositories/auth_repository.dart';

part 'otp_event.dart';
part 'otp_state.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  OtpBloc() : super(OtpInitial()) {
    on<OtpEvent>((event, emit) {});
    on<OtpVerifyEvent>(otpVerifyEvent);
  }

  FutureOr<void> otpVerifyEvent(
      OtpVerifyEvent event, Emitter<OtpState> emit) async {
    String result = await AuthRepo.verifyotp(event.email, event.otp);
    emit(OtpVarifyLoadingState());
    if (result == 'Successful') {
      emit(OtpVarifySuccessfulState());
    } else if (result == 'Invalid verification code or OTP expired') {
      emit(OtpVarifyInvalidPasswordState());
    } else if (result == 'Something went wrong please try after sometime.') {
      emit(OtpVarifyServerErrorState());
    } else {
      emit(OtpVarifyErrorState());
    }
  }
}
